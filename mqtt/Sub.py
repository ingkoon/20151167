# import pika

# connection = pika.BlockingConnection(pika.ConnectionParameters(host = '192.168.1.101', port = ))

# channel = connection.channel()

# channel.queue_declare(queue = 'Hello')

# def callback(ch, method, properties, body):
#     print("수신완료: %r"%body)


# print("새 메시지 대기중. 종료를 원할 시, ctrl + C를 누르세요")

# channel.start_consuming()

import pika 
class Publisher: 
    def __init__(self): 
        self.__url = '192.168.1.101' 
        self.__port = 5672 
        self.__vhost = 'master' 
        self.__cred = pika.PlainCredentials('master', 'cucumber52') 
        self.__queue = 'test_mq'; return 
    
    def main(self): 
        conn = pika.BlockingConnection(pika.ConnectionParameters(self.__url, self.__port, self.__vhost, self.__cred)) 
        chan = conn.channel() 
        chan.basic_publish( exchange = '', routing_key = self.__queue, body = 'Hello RabbitMQ' ) 
        conn.close() 
        return 

publisher = Publisher() 
publisher.main()

