local function wifi_connected_callback(iptable)
  print("wifi_connected_callback")
  print("ip: " .. iptable.IP)
  dofile("brain.lua")
end

wificonf = {
  ssid = "iPhone de Joao ",
  pwd = "joao12345",
  got_ip_cb = wifi_connected_callback,
  save = true,
}

wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)

  --ssid = "SANACLITA",
  --pwd = "0335AA3881393675070EF02052AFC87E4AA372B273FFF1242DF13BA85CB69B2D",