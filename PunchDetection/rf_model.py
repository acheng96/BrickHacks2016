import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.ensemble import RandomForestClassifier 
from sklearn.externals import joblib 

import re


df_train = pd.read_csv('train1_2.csv', header = 0)
df_test = pd.read_csv('train2_2.csv', header = 0)
train = df_train.append(df_test)
train['punch'] = pd.factorize(train.punch)[0]

features = ['acc_y', 'acc_z', 'acc_mag', 'gyro_x', 'gyro_y', 'gyro_z', 'gyro_mag', 'log_gyro_mag']

forest = RandomForestClassifier(oob_score = True, n_estimators = 500)
rf = forest.fit(train[features], train['punch'])
pred = rf.predict(train[features])

joblib.dump(rf, 'rf_model.pkl')


