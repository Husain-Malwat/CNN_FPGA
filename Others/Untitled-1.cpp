#include<iostream>
#include<string.h>
using namespace std;

int main(){

    char s;
	s=cin.get();

	int space = 0;
    int digi = 0;
    int charac = 0;

    while(s!='$')
    {
	
        int x; 
        x=s;
        if(x>96 && x<123)
        {
            charac++;
        }
        else if( x>47 && x<58)
        {
            digi++;
        }
        else if (s==' ')
        {
            space++;
        }
        s=cin.get();
    }
    
    
    cout<< charac<<" "<<digi<< " "<<space;
}


