import pika, sys, os

from pika.connection import Parameters

def main():
    credentials = pika.PlainCredentials('master', 'cucumber52')
    connection = pika.BlockingConnection(pika.ConnectionParameters('192.168.1.101', port = 5672, virtual_host='master', credentials= credentials))
    channel = connection.channel()
    
    channel.queue_declare(queue = 'test_mq', durable=  True, exclusive= False, auto_delete= False)

    def callback(ch, method, properties, body):
        print("수신완료: %s" %body)


    channel.basic_consume(queue='test_mq', on_message_callback=callback, auto_ack=True)
    print("새 메시지 대기중. 종료를 원할 시, ctrl + C를 누르세요")

    channel.start_consuming()

if __name__=='__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)


# import pika 
# class Publisher: 
#     def __init__(self): 
#         self.__url = '192.168.1.101' 
#         self.__port = 5672 
#         self.__vhost = 'master' 
#         self.__cred = pika.PlainCredentials('master', 'cucumber52') 
#         self.__queue = 'test_mq'; return 
    
#     def main(self): 
#         conn = pika.BlockingConnection(pika.ConnectionParameters(self.__url, self.__port, self.__vhost, self.__cred)) 
#         chan = conn.channel() 
#         chan.basic_publish( exchange = '', routing_key = self.__queue, body = 'Hello RabbitMQ' ) 
#         conn.close() 
#         return 

# publisher = Publisher() 
# publisher.main()

