param VmManagementserver string

resource managementserver 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: VmManagementserver
}
