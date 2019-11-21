local MQTT = {}

local PORT = 1883 -- default port, substitute if necessary

local userId = nil
local mqttClient = nil

local mqtterror = {}
mqtterror[-5] = "There is no broker listening at the specified IP Address and Port"
mqtterror[-4] = "Wrong response from server"
mqtterror[-3] = "Lookup for server address failed"
mqtterror[-2] = "Timeout waiting for a CONNACK from the broker"
mqtterror[-1] = "Timeout trying to send the Connect message"
mqtterror[0] = "No errors"
mqtterror[1] = "The broker is not a 3.1.1 MQTT broker"
mqtterror[2] = "The specified ClientID was rejected by the broker. (See mqtt.Client())"
mqtterror[3] = "The server is unavailable"
mqtterror[4] = "The broker refused the specified username or password"
mqtterror[5] = "The username is not authorized"
--
-- private functions

local callback
local channel
local defaultTopic

local function mqttConnected()
  print('Connected to broker')
  local channel = channel or userId..'node'
  mqttClient:subscribe(channel,0,function(conn)
    print('succesfuly subscribed to '.. channel) 
  end)
end

local function mqttConnect(host)
  local attempts = 3

  local function mqttcouldnotconnect (con,reason) 
    print ("connection failed:")
    if reason >= -5 and reason <= 5 then print (mqtterror[reason]) 
    else print(reason) end
    attempts = attempts - 1
    if attempts>0 and not (reason==-1 or reason==-2) then
      print('new attempt to connect')
      mqttClient:connect(host, PORT, false, mqttConnected, mqttcouldnotconnect) 
    else
      print("giving up on broker")
    end
  end

  print('Attempt to connect')
  mqttClient:connect(host,PORT,false, mqttConnected, mqttcouldnotconnect)
end

--[[
  function to start the mqttClient. It connects to the broker and subscribes to a predefined channel.
  id: unique id for the user
  callbackFunction: optional, function to be called when the application receives a message. 
]]
function MQTT.start(host, id, userchannel, callbackFunction)
  defaultTopic = id .. 'love' -- default topic for publishing
  mqttClient = mqtt.Client(id .. 'node',120) 
  userId = id
  callback = callbackFunction 
  channel = userchannel
  mqttClient:on("offline", function(client) print ("offline") end)
  mqttClient:on("message", function(client, topic, message)
    print("received  message " .. message .. " from topic  " .. topic)
    callback(message)
  end)
  mqttConnect(host)
end

--[[
  function to send a message
  message: message to be sent
  topic: optional, channel to send the message. If nil the message will be sent to a default channel
]]
function MQTT.sendMessage(message, topic)
  topic = topic or defaultTopic
  print("sending message " .. message .. " to topic " .. topic)
  mqttClient:publish(topic,message,0,0, function(client) end)
end

return MQTT