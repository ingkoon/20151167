import pika
import time

credentials = pika.PlainCredentials('master', 'cucumber52')
connection = pika.BlockingConnection(pika.ConnectionParameters('192.168.1.101', port = 5672, virtual_host='master', credentials= credentials))
channel = connection.channel()
    
channel.queue_declare(queue = 'test_mq', durable=  True, exclusive= False, auto_delete= False)


def test():
    for i in range(10):
        channel.basic_publish(exchange='', routing_key='test_mq', body='Hello RabbitMQ!')
        print(" [x] Sent 'Hello RabbitMQ! %d'" %i)
        time.sleep(1)


test()
connection.close()
