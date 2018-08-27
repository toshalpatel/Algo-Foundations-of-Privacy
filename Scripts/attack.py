#!/usr/bin/python

import numpy as np
import math
from collections import Counter

n = 10
m = 350
URL = [[0] * n for i in range (m)]
TEST=[]


def outPOL():
	k=0
	for i in range(1,11):
		for j in range(0,35):
			filename="day_"+str(i)+"_pol_URL_"+str(j)+".txt"
			#print("Reading file: "+filename)
			fpol = open(filename, "r")
			inp=[]
			outp=[]
			totalp=[]
			pol=[]
			for line in fpol:
				pol=line.split()
				inp.append(int(pol[0]))
				outp.append(int(pol[1]))
				totalp.append(int(pol[2]))
			inp = np.array(inp)
			outp = np.array(outp)
			totalp = np.array(totalp)
			sdin = np.std(inp)
			sdout = np.std(outp)
			sdtotal = np.std(totalp)
			#sd = [sdin, sdout, sdtotal]
			sd = math.sqrt(float(sdin**2 + sdout**2 + sdtotal**2)/3)
			avgin = np.average(inp)
			avgout = np.average(outp)
			avgtotal = np.average(totalp)
			avg = math.sqrt(float(avgin**2 + avgout**2 + avgtotal**2)/3)
			URL[k][0] = j
			URL[k][1] = sd
			URL[k][2] = avg
			k=k+1
	print("Completed for %s urls",k)

def inPOL():
	k=0
	for i in range(1,11):
		for j in range(0,35):
			filename="day_"+str(i)+"_inpol_URL_"+str(j)+".txt"
			#print("Reading file: "+filename)
			fpol = open(filename, "r")
			inp=[]
			outp=[]
			totalp=[]
			pol=[]
			for line in fpol:
				pol=line.split()
				inp.append(int(pol[0]))
				outp.append(int(pol[1]))
				totalp.append(int(pol[2]))
			inp = np.array(inp)
			outp = np.array(outp)
			totalp = np.array(totalp)
			sdin = np.std(inp)
			sdout = np.std(outp)
			sdtotal = np.std(totalp)
			#sd = [sdin, sdout, sdtotal]
			sd = math.sqrt(float(sdin**2 + sdout**2 + sdtotal**2)/3)
			avgin = np.average(inp)
			avgout = np.average(outp)
			avgtotal = np.average(totalp)
			avg = math.sqrt(float(avgin**2 + avgout**2 + avgtotal**2)/3)
			URL[k][3] = sd
			URL[k][4] = avg
			k=k+1
	print("Completed for %s urls",k)


def packetStats():
	k=0
	for i in range(1,11):
		filename="day_"+str(i)+"_inout.txt"
		#print("Reading file: "+filename)
		fpol = open(filename, "r")
		inp=[]
		outp=[]
		totalp=[]
		pol=[]
		for line in fpol:
			pol=line.split()
			inp.append(int(pol[1]))
			outp.append(int(pol[2]))
			totalp.append(int(pol[3]))
		inp = np.array(inp)
		outp = np.array(outp)
		totalp = np.array(totalp)
		sin = np.sum(inp)
		sout = np.sum(outp)
		stotal = np.sum(totalp)
		URL[k][5] = sin
		URL[k][6] = float(sout)/stotal
		URL[k][7] = float(sin)/stotal
		URL[k][8] = sout
		URL[k][9] = sin + sout + stotal
		k=k+1
	print("Completed for %s urls",k)
	

def loadData():
	outPOL()
	inPOL()
	packetStats()
	TRAIN = np.array(URL)
	#fileout = "attack_data.txt"
	np.savetxt('attack_data.txt', delimiter=',')
	
	print("Data loaded...")
	count=0
	for url in URL:
		#print(url)
		count=count+1
	print(str(count)+" urls loaded...")
	
	
def calcDist(test, url):
	dist = math.sqrt((test[0] - url[0])**2 + (test[1] - url[1])**2 + (test[2] - url[2])**2)
	return dist 
		

def loadTestData():
	print("Test data loaded...")

	
def runAttack():
	print("Now running attack for the given fingerprints...")
	for pt in range(0, 35):
		
		predictions= []
		distance=[]
		for j in range (1,11):
			for i in range(0,34):
				dist = calcDist(TEST[pt], URL[i][j])
				distance.append([dist, i])
		distance = sorted(distance)
		#print(distance)
		k=5
		for i in range(k):
			index = distance[i][1]
			predictions.append(index)
		#print("Predictions: ")
		#print(predictions)
		cnt=Counter(predictions)
		print("Packet trace"+ str(pt) + ", url mapped..." + str(cnt.most_common(1)[0][0]))
	
	
loadData()
		
		
		
		
			
			
		
		
		
