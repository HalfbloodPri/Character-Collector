# encoding: utf-8
from PyQt5.QtCore import pyqtSlot, QObject
import numpy as np
from PIL import Image
import os
import time

class MnistHandler(QObject):

    mnistImgWidth = 28         #mnist数据集中图片的宽度
    mnistImgHeight = 28        #mnist数据集中图片的高度
    mnistData = np.zeros((mnistImgHeight,mnistImgWidth)).astype('uint8')
    personPropertyInit = {'0':0, '1':0, '2':0, '3':0, '4':0, '5':0, '6':0, '7':0, '8':0, '9':0}
    try:
        personPropertyFile = open('property.txt','r')
        personProperty = eval(personPropertyFile.read())
        personPropertyFile.close()
    except IOError as e:
        print('Property file does not exit. A new property.txt will be created.')
        personPropertyFile = open('property.txt','w')
        personProperty = {'All': personPropertyInit.copy()}
        personPropertyFile.write(str(personProperty))
        personPropertyFile.close()

    #此函数用于将图片进行像素化，对RGB值均取平均
    @pyqtSlot(str,str)
    def setImageData(self,numStr,name):
        r'''
        把原图片像素化之后存储成图片mnistImagePixelate.bmp，供界面显示用；
        '''
        try:
            img = Image.open("mnistImage.bmp")
            imgGray = Image.open("init.bmp")
        except IOError as e:
            print("Failed to open MNIST image.")
        else:
            imageWidth, imageHeight = img.size
            hPixels = int(imageWidth/self.mnistImgHeight)
            wPixels = int(imageWidth/self.mnistImgWidth)
            imageData = np.array(img.getdata(0))        #获得图片RGB中的R
            imageData = imageData.reshape(imageHeight,imageWidth)
            #把原图片进行像素化，用于显示；
            for row in range(self.mnistImgHeight):
                for column in range(self.mnistImgWidth):
                    grayVal = int(imageData[row*hPixels:(row+1)*hPixels,column*wPixels:(column+1)*wPixels].sum()/(hPixels*wPixels))
                    self.mnistData[row][column] = grayVal
                    imageData[row*hPixels:(row+1)*hPixels,column*wPixels:(column+1)*wPixels] = grayVal*np.ones((hPixels,wPixels))
            imageData = imageData.reshape(1,imageHeight*imageWidth)
            img.putdata(tuple(map(tuple,imageData.repeat(3).reshape(imageData.size,3))))
            img.save("mnistImagePixelate.bmp")
            imgGray.putdata(tuple(map(tuple,self.mnistData.repeat(3).reshape(self.mnistData.size,3))))
            numNo = int(numStr)*100000 + self.personProperty['All'][numStr]
            self.personProperty['All'][numStr] += 1
            if name in self.personProperty:
                self.personProperty[name][numStr] += 1
            else:
                self.personProperty[name] = self.personPropertyInit.copy()
                self.personProperty[name][numStr] += 1
            fileName = '{:0>6d}'.format(numNo) + '.bmp'
            imgGray.save("nums/"+fileName)
            try:
                personPropertyFile = open('property.txt','w')
                personPropertyFile.write(str(self.personProperty))
            except IOError as e:
                print(str(e))

    @pyqtSlot(str,result=list)
    def getNumList(self,name):
        numList = []
        for i in range(10):
            numList.append(str(self.personProperty[name][str(i)]))
        return numList.copy()
mnistHandler = MnistHandler()