#!/usr/bin/python
# apache_loggen.py
import time
import datetime
import random
timestr = time.strftime("%Y%m%d-%H%M%S")
 
f = open('access_log_'+timestr+'.log','w')
 
ips=["123.221.14.56","16.180.70.237","10.182.189.79","218.193.16.244","198.122.118.164","114.214.178.92","233.192.62.103","244.157.45.12","81.73.150.239","237.43.24.118"]
referers=["-","http://www.cyclingnews.com", "http://www.casualcyclist.com","http://bestcyclingreviews.com/top_online_shops","http://inrng.com","http://www.cyclingweekly.co.uk"]
resources=["/races","/handle-bars","/stems","/wheelsets","/forks","/seatposts","/saddles","/shifters","/Store/cart.jsp?productID="]
useragents=["Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)","Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36","Mozilla/5.0 (Linux; U; Android 2.3.5; en-us; HTC Vision Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1","Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25","Mozilla/5.0 (Windows; U; Windows NT 6.1; rv:2.2) Gecko/20110201","Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Firefox/31.0","Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))"]
 
otime = datetime.datetime(2014,9,25)
 
for i in xrange(0,500):
	increment = datetime.timedelta(seconds=random.randint(30,300))
	otime += increment
	uri = random.choice(resources)
	if uri.find("Store")>0:
		uri += `random.randint(1000,1500)`
	ip = random.choice(ips)
	useragent = random.choice(useragents)
	referer = random.choice(referers)
	f.write('%s - - [%s] "GET %s HTTP/1.0" 200 %s "%s" "%s"\n' % (random.choice(ips),otime.strftime('%d/%b/%Y:%H:%M:%S %z'),uri,random.randint(2000,5000),referer,useragent))