Function ping
Parameters pHOST
Local I,J,K,K_OK,K_ERR
If Parameters()<1
	pHOST='192.168.0.1'
Endif
Declare Integer IcmpCreateFile In icmp
Declare Integer IcmpSendEcho In icmp Integer ID_ICMP, Integer IP_ADDR,;
	string @ReqData, Integer ReqSize, String @ReqOptions,;
	string @RepBuffer, Integer RepSize, Integer WaitTime
Declare Integer IcmpCloseHandle In icmp Integer ID_icmp

Declare Integer inet_addr In Ws2_32 String IPHOST

*********************************************************
Store 0 To K_OK,K_ERR
K=1

* set alternate to ping.log
* set alternate on
* set console off

* ? 'Проверка связи c',pHOST,'начата в',datetime()
* ? replicate('-',70)
For I=1 To K
*	Wait Window Str(I)+' / '+Str(K) Nowait
	J=hostping(pHOST)
	If J
		K_OK=K_OK+1
	Else
		K_ERR=K_ERR+1
	Endif
	J=Seconds()
	Do While Seconds()-J<0.1
	Enddo
Next
*Wait Clear
* ? replicate('-',70)
* ? 'Проверка связи c',pHOST,'окончена в',datetime()
* ? '   Отправлено пакетов',K,'из них получено',K_OK,'потеряно',K_ERR
* ? replicate('-',70)
* ?

* close alternate
* set console on
Return K_OK
Endfunc