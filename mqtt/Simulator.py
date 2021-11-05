from simglucose.simulation.env import T1DSimEnv
from simglucose.controller.basal_bolus_ctrller import BBController
from simglucose.sensor.cgm import CGMSensor
from simglucose.actuator.pump import InsulinPump
from simglucose.patient.t1dpatient import T1DPatient
from simglucose.simulation.scenario_gen import RandomScenario
from simglucose.simulation.scenario import CustomScenario
from simglucose.simulation.sim_engine import SimObj, sim, batch_sim
from datetime import timedelta
from datetime import datetime

from paho.mqtt import client as mqtt_client



# specify start_time as the beginning of today

host = "192.168.1.101"
port = 1883
topic = "connect-mqtt"
client_id = "orlando"

client = mqtt_client.Client(client_id)
client.connect(host) 

# class setHost:    
#     def setData(self, host, port, topic, client_id):
#         self.host = host
#         self.port = port
#         self.topic = topic
#         self.client_id = client_id    
        
#     def connectMq(self):
#         client = mqtt_client.Client(self.client_id)
#         client.connect(self.host)

now = datetime.now()
start_time = datetime.combine(now.date(), datetime.min.time())

# --------- Create Random Scenario --------------
# Specify results saving path
path = './results'

# Create a simulation environment
patient = T1DPatient.withName('child#01')
sensor = CGMSensor.withName('GuardianRT', seed=1)
pump = InsulinPump.withName('Insulet')
scen = [(7, 45), (12, 70), (16, 15), (18, 80), (23, 10)]
scenario = CustomScenario(start_time=start_time, scenario=scen)
env = T1DSimEnv(patient, sensor, pump, scenario)

# Create a controller
controller = BBController()

# Put them together to create a simulation object
s1 = SimObj(env, controller, timedelta(days=1), animate=False, path=path)
results1 = sim(s1)
print(results1)

# --------- Create Custom Scenario --------------
# Create a simulation environment
# patient = T1DPatient.withName('adolescent#001')
# sensor = CGMSensor.withName('Dexcom', seed=1)
# pump = InsulinPump.withName('Insulet')
# # custom scenario is a list of tuples (time, meal_size)
# scen = [(7, 45), (12, 70), (16, 15), (18, 80), (23, 10)]
# scenario = CustomScenario(start_time=start_time, scenario=scen)
# env = T1DSimEnv(patient, sensor, pump, scenario)

# # Create a controller
# controller = BBController()

# # Put them together to create a simulation object
# s2 = SimObj(env, controller, timedelta(days=1), animate=False, path=path)
# results2 = sim(s2)
# print(results2)


# --------- batch simulation --------------
# Re-initialize simulation objects
# s1.reset()
# s2.reset()

# create a list of SimObj, and call batch_sim
# s = [s1, s2]
# results = batch_sim(s, parallel=False)
# print(results)