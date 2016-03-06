
from __future__ import print_function

import myo as libmyo; libmyo.init()
import time
import csv
import sys
import math 
import os
from vector import Vector
import feedback


data = [['acc_y', 'acc_z','acc_mag','gyro_x','gyro_y','gyro_z', 'gyro_mag', 'log_gyro_mag']]

class Listener(libmyo.DeviceListener):
    """
    Listener implementation. Return False from any function to
    stop the Hub.
    """

    interval = 0.05  # Output only 0.05 seconds
    period = .5 # take data every 1.00 seconds

    def __init__(self):
        super(Listener, self).__init__()
        #self.orientation = None
        #self.pose = libmyo.Pose.rest
        #self.emg_enabled = False
        #self.locked = False
        #self.rssi = None
        #self.emg = None
        self.acceleration = Vector(0, 0, 0)
        self.gyroscope = Vector(0, 0, 0)
        self.last_time = 0
        self.last_data = 0
        #self.acc_x_sum = 0
        self.acc_y_sum = 0
        self.acc_z_sum = 0
        #self.acc_z_raw_sum = 0

        self.acc_mag_sum = 0
        self.gyro_x_sum = 0
        self.gyro_y_sum = 0
        self.gyro_z_sum = 0
        self.gyro_mag_sum = 0
        self.log_gyro_mag_sum = 0

    def output(self):
        ctime = time.time()
        if (ctime - self.last_time) < self.interval:
            return
        self.last_time = ctime

        #acc_x = abs(self.acceleration[0] * 10);
        acc_y = abs(self.acceleration[1] * 10);
        acc_z = abs(self.acceleration[2] * 10);
        #acc_z_raw = self.acceleration[2] * 10;
        acc_mag = self.acceleration.magnitude() * 10;


        gyro_x = abs(self.gyroscope[0]);
        gyro_y = abs(self.gyroscope[1]);
        gyro_z = abs(self.gyroscope[2]);
        gyro_mag = self.gyroscope.magnitude() * 10 ;

        #self.acc_x_sum += acc_x
        self.acc_y_sum += acc_y
        self.acc_z_sum += acc_z
        #self.acc_z_raw_sum += acc_z_raw
        self.acc_mag_sum += acc_mag
        self.gyro_x_sum += gyro_x
        self.gyro_y_sum += gyro_y
        self.gyro_z_sum += gyro_z
        self.gyro_mag_sum += gyro_mag

        if (ctime - self.last_data) > self.period:
            d = (ctime - self.last_data) / self.interval
            parts = []
            #parts.append(self.acc_x_sum/d)
            parts.append(self.acc_y_sum/d)
            parts.append(self.acc_z_sum/d)
            parts.append(self.acc_mag_sum/d)
            parts.append(self.gyro_x_sum/d)
            parts.append(self.gyro_y_sum/d)
            parts.append(self.gyro_z_sum/d)
            parts.append(self.gyro_mag_sum/d)
            #arts.append(self.acc_z_raw_sum/d)

            if self.gyro_mag_sum == 0:
                parts.append(0)
            else:
                parts.append(math.log(self.gyro_mag_sum/d))

            data.append(parts)
            self.last_data = ctime

            self.acc_x_sum = 0
            self.acc_y_sum = 0
            self.acc_z_sum = 0
            #self.acc_z_raw_sum = 0
            self.acc_mag_sum = 0
            self.gyro_x_sum = 0
            self.gyro_y_sum = 0
            self.gyro_z_sum = 0
            self.gyro_mag_sum = 0
            self.log_gyro_mag_sum = 0


        #if self.orientation:
        #    for comp in self.orientation:
        #        parts.append(str(comp).ljust(15))
        #parts.append(str(self.pose).ljust(10))
        #parts.append('E' if self.emg_enabled else ' ')
        #parts.append('L' if self.locked else ' ')
        #parts.append(self.rssi or 'NORSSI')
        #if self.emg:
        #    for comp in self.emg:
        #        parts.append(str(comp).ljust(5))
        #print('\r' + ''.join('[{0}]'.format(p) for p in parts), end='\n')

        sys.stdout.flush()

    """
    def on_connect(self, myo, timestamp, firmware_version):
        myo.vibrate('short')
        myo.vibrate('short')
        myo.request_rssi()
        myo.request_battery_level()

    def on_rssi(self, myo, timestamp, rssi):
        self.rssi = rssi
        self.output()

    def on_pose(self, myo, timestamp, pose):
        if pose == libmyo.pose.fist:
            self.pose = libmyo.pose.fist
        else:
            self.pose = libmyo.pose.rest

        self.output()
    """

    def on_orientation_data(self, myo, timestamp, orientation):
        self.orientation = orientation
        self.output()

    def on_accelerometor_data(self, myo, timestamp, acceleration):
        self.acceleration = acceleration
        self.output()

    def on_gyroscope_data(self, myo, timestamp, gyroscope):
        self.gyroscope = gyroscope
        self.output()

    """
    def on_emg_data(self, myo, timestamp, emg):
        self.emg = emg
        self.output()

    def on_unlock(self, myo, timestamp):
        self.locked = False
        self.output()

    def on_lock(self, myo, timestamp):
        self.locked = True
        self.output()

    def on_event(self, kind, event):
        Called before any of the event callbacks.

    def on_event_finished(self, kind, event):
        Called after the respective event callbacks have been
        invoked. This method is *always* triggered, even if one of
        the callbacks requested the stop of the Hub.

    def on_pair(self, myo, timestamp, firmware_version):
        Called when a Myo armband is paired.

    def on_unpair(self, myo, timestamp):
        Called when a Myo armband is unpaired.

    def on_disconnect(self, myo, timestamp):
        Called when a Myo is disconnected.

    def on_arm_sync(self, myo, timestamp, arm, x_direction, rotation,
                    warmup_state):
        Called when a Myo armband and an arm is synced.

    def on_arm_unsync(self, myo, timestamp):
        Called when a Myo armband and an arm is unsynced.

    def on_battery_level_received(self, myo, timestamp, level):
        Called when the requested battery level received.

    def on_warmup_completed(self, myo, timestamp, warmup_result):
        Called when the warmup completed.
    """

def main():
    print("Connecting to Myo ... Use CTRL^C to exit.")
    try:
        hub = libmyo.Hub()
    except MemoryError:
        print("Myo Hub could not be created. Make sure Myo Connect is running.")
        return

    hub.set_locking_policy(libmyo.LockingPolicy.none)
    hub.run(1000, Listener())

    # Listen to keyboard interrupts and stop the hub in that case.
    try:
        while hub.running:
            time.sleep(0.25)
    except KeyboardInterrupt:
        print("\nQuitting ...")
    finally:
        print("Shutting down hub...")

        with open('train.csv', 'w') as fp:
            a = csv.writer(fp, delimiter = ',')
            a.writerows(data)

        feedback.main()

        hub.shutdown()



if __name__ == '__main__':
    main()

