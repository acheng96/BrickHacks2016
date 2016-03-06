import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math

from sklearn.ensemble import RandomForestClassifier 
from sklearn.externals import joblib 

import re


def main():
    train = pd.read_csv('train.csv', header = 0)
    clf = joblib.load('rf_model.pkl') 
    pred = clf.predict(train)
    max = 0 
    counter = 0
    index = 0
    for i in range(pred.size):
    	if pred[i] == 1:
            counter+=1
            if train['gyro_mag'][i]*train['acc_y'][i] > max:
    	       index = i
               max = train['gyro_mag'][i]*train['acc_y'][i]

    if max == 0:
    	print("You Didn't Punch")
    else:
    	print("Nice punches!")
        print("Total Punches: " + str(int(math.ceil(counter - 0.25*counter))))
    	print("Power (Best): " + str(max))

if __name__ == '__main__':
    main()