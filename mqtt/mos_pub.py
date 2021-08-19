from paho.mqtt import client as mqtt_client
import time

host = "192.168.1.101"
port = 1883
topic = "connect-mqtt"
client_id = "orlando"

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connecting Success")
        else:
            print("Failed  to connect return code %d\n",rc)
        
    client = mqtt_client.Client(client_id)    
    client.on_connect = on_connect
    client.connect(host)
    return client

def publish(client):
    msg_count = 0
    while True:
        time.sleep(1)
        msg = f"messages: count = {msg_count}"
        result = client.publish(topic, msg)
        # result: [0, 1]
        status = result[0]
        if status == 0:
            print(f"Send `{msg}` to topic `{topic}`")
        else:
            print(f"Failed to send message to topic {topic}")
        msg_count += 1


def run():
    client = connect_mqtt()
    client.loop_start()
    publish(client)


if __name__ == '__main__':
    run()