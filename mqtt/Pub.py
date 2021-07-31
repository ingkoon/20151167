import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host='192.168.1.101',port = 5672, virtual_host  = '/',credentials=pika.PlainCredentials('master', 'cucumber52')))

channel = connection.channel()


for i in range(10000):
    channel.basic_publish(exchange = '', routing_key = 'Hello', body = str(i))
    print("# 메시지 전송 완료" + str(i))

connection.close()
