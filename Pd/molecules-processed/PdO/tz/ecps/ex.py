#Variables
conv = 27.211386
bkc1gs = -127.27054181
bkc4gs = -127.30464831
bkc5gs = -127.38233810
#bk6gs = -127.66212850
bk7gs = -127.76713118
ox = -15.86703857
off1 = bkc1gs + ox
off4 = bkc4gs + ox
off5 = bkc5gs + ox
off7 = bk7gs + ox

#Binding Energies
ae19 = -0.07259636
bkc1_19 = -143.2109049 - off1
bkc4_19 = -143.2450383 - off4
bkc5_19 = -143.3229647 - off5
#bk6_19 = (-143.7098303 - bk6gs - ox)*conv
bk7_19 = -143.7089954 - off7

ae18 = -0.07858317
bkc1_18 = -143.2166115 - off1
bkc4_18 = -143.2507909 - off4
bkc5_18 = -143.3288882 - off5
bk7_18 = -143.7158104 - off7

ae16 = -0.06962019
bkc1_16 = -143.2072536 - off1
bkc4_16 = -143.2415111 - off4
bkc5_16 = -143.3198754 - off5
bk7_16 = -143.7082766 - off7
#Differences
bkc1_19er = (ae19 - bkc1_19)*conv
bkc4_19er = (ae19 - bkc4_19)*conv
bkc5_19er = (ae19 - bkc5_19)*conv
bk7_19er = (ae19 - bk7_19)*conv

bkc1_18er = (ae18 - bkc1_18)*conv
bkc4_18er = (ae18 - bkc4_18)*conv
bkc5_18er = (ae18 - bkc5_18)*conv
bk7_18er = (ae18 - bk7_18)*conv

bkc1_16er = (ae16 - bkc1_16)*conv
bkc4_16er = (ae16 - bkc4_16)*conv
bkc5_16er = (ae16 - bkc5_16)*conv
bk7_16er = (ae16 - bk7_16)*conv

print("bkc1.1",bkc1_19er,bkc1_18er,bkc1_16er)
print("bkc4.1",bkc4_19er,bkc4_18er,bkc4_16er)
print("bkc5.1",bkc5_19er,bkc5_18er,bkc5_16er)
print("bk7.5.2",bk7_19er,bk7_18er,bk7_16er)
