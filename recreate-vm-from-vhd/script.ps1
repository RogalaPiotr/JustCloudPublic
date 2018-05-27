$vms = @("SimpleWindowsVM")
$sourcecontainerimage = "images"
function recreatevms {
    foreach ($vm in $vms) {
        Write-Host "VM name: "$vm
        $vmrg = Get-AzureRmResource | Where-Object {$_.Name -like $vm}
        Write-Host "VM Resource Group: "$vmrg.ResourceGroupName
        $vmsize = (Get-AzureRmVM -ResourceGroupName $vmrg.ResourceGroupName -VMName $vm).HardwareProfile.VmSize
        Write-Host "VM size: "$vmsize
        $nicvm = Get-AzureRmNetworkInterface -ResourceGroupName $vmrg.ResourceGroupName | Where-Object {$_.VirtualMachine.Id -like "*$vm*"}
        Write-Host "VM NIC name: "$nicvm.Name
        $vmstatus = Get-AzureRmVM -ResourceGroupName $vmrg.ResourceGroupName -Name $vm -Status
        Write-Host "VM status is: "$vmstatus.Statuses.DisplayStatus[1]
        if($vmstatus.Statuses.DisplayStatus -like "*running*"){
            Write-Host "VM stopping: "$vm
            $tmp = Stop-AzureRmVM -ResourceGroupName $vmrg.ResourceGroupName -Name $vm -Force
        }
        $vmdiskos = ((Get-AzureRmVM -ResourceGroupName $vmrg.ResourceGroupName -Name $vm).StorageProfile).OsDisk 3> $null
        $vmdisksdata = ((Get-AzureRmVM -ResourceGroupName $vmrg.ResourceGroupName -Name $vm).StorageProfile).DataDisks 3> $null
        Write-Host "Get VM disk os: "$vmdiskos.Name 
        Write-Host "Get VM disk data: "$vmdisksdata.Name
        Write-Host "Get VM disk data count: "$vmdisksdata.Count

        $storagediskosname = ($vmdiskos.Vhd.Uri.Split("/")[2]).Replace(".blob.core.windows.net","")
        $containerdiskos = ($vmdiskos.Vhd.Uri.Split("/")[3])
        $vmdiskosname = ($vmdiskos.Vhd.Uri.Split("/")[4])
        $storageaccountos = Get-AzureRmResource | Where-Object {$_.Name -like "$storagediskosname"}
        $storageaccountkeyos = (Get-AzureRmStorageAccountKey -Name $storageaccountos.Name -ResourceGroupName $storageaccountos.ResourceGroupName).Value[0]
        $storagecontext = New-AzureStorageContext -StorageAccountName $storageaccountos.Name -StorageAccountKey $storageaccountkeyos
        $container = Get-AzureStorageContainer -Name $containerdiskos -context $storagecontext

        $containerdiskosimage = $vmdiskos.Vhd.Uri -replace("vhds",$sourcecontainerimage)
        
        Remove-AzureRmVM -Name $vm -ResourceGroupName $vmrg.ResourceGroupName -Force
        Write-Host "Removing VM: "$vm
        Remove-AzureStorageBlob -Blob $vmdiskosname -Container vhds -Context $storagecontext
        Write-Host "Removing VM os disk uri: "$vmdiskos.Vhd.Uri
        $tmp = Start-AzureStorageBlobCopy -srcUri $containerdiskosimage -SrcContext $storagecontext -DestContainer $containerdiskos -DestBlob $vmdiskosname -DestContext $storagecontext
        Write-Host  "Copying new os disk uri: "$containerdiskosimage

        if (![string]::IsNullOrEmpty($vmdisksdata)){
            foreach ($vmdiskdata in $vmdisksdata){

                $storagediskdataname = ($vmdiskdata.Vhd.Uri.Split("/")[2]).Replace(".blob.core.windows.net","")
                $containerdiskdata = ($vmdiskdata.Vhd.Uri.Split("/")[3])
                $vmdiskdataname = ($vmdiskdata.Vhd.Uri.Split("/")[4])
                $storageaccountdata = Get-AzureRmResource | Where-Object {$_.Name -like "$storagediskdataname"}
                $storageaccountkeydata = (Get-AzureRmStorageAccountKey -Name $storageaccountdata.Name -ResourceGroupName $storageaccountdata.ResourceGroupName).Value[0]
                $storagecontext = New-AzureStorageContext -StorageAccountName $storageaccountdata.Name -StorageAccountKey $storageaccountkeydata
                $container = Get-AzureStorageContainer -Name $containerdiskdata -context $storagecontext
                
                $containerdiskdataimage = $vmdiskdata.Vhd.Uri -replace("vhds",$sourcecontainerimage)
                        
                Remove-AzureStorageBlob -Blob $vmdiskdataname -Container vhds -Context $storagecontext
                Write-Host "Removing VM data disk uri: "$vmdiskdata.Vhd.Uri
                $tmp = Start-AzureStorageBlobCopy -srcUri $containerdiskdataimage -SrcContext $storagecontext -DestContainer $containerdiskdata -DestBlob $vmdiskdataname -DestContext $storagecontext
                Write-Host  "Copying new os disk uri: "$containerdiskdataimage
            }  
        }
        Write-Host "Creating VM"
        $vmConfig = New-AzureRmVMConfig -VMName $vm -VMSize $vmsize
        $vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name $vmdiskos.Name -VhdUri $vmdiskos.Vhd.Uri -CreateOption Attach -Windows
        if ($vmdisksdata.count -ge 0){
            $i = 0
            foreach ($vmdiskdatavm in $vmdisksdata){
                $vmConfig = Add-AzureRmVMDataDisk -VM $vmConfig -VhdUri $vmdiskdatavm.Vhd.Uri -CreateOption Attach -Lun $i -Name $vmdiskdatavm.Name -Caching ReadWrite
                $i++
            }
        }
        $vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nicvm.Id
        $vmConfig = Set-AzureRmVMBootDiagnostics -VM $vmConfig -Disable
        $vm = New-AzureRmVM -VM $vmConfig -Location $vmrg.Location -ResourceGroupName $vmrg.ResourceGroupName
    }   
}
############################################################################################################
# Recreate VM
############################################################################################################

recreatevms
