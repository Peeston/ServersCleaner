parameters pStr,pN 
* pSTR - ������������� ������
* pN   - ����������� ���������� ���� � ����� 
*          0 - ������ ������
*          1 - ����� ������� (�� ���������)
local I,J,K
 if parameters()<2
  PN=1
 endif
 J=0
 for I=1 to len(PStr)
  K=256^(iif(PN>0,I-1,len(PStr)-I))
  J=J+asc(substr(PStr,I,1))*K
 next
return J
