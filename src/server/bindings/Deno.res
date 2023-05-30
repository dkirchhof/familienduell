type networkInterface = {
  family: string,
  address: string,
  netmask: string,
}

@var external networkInterfaces: unit => array<networkInterface> = "Deno.networkInterfaces"
