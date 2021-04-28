#include <stdio.h>

void go_print(char *str) {

printf("hello %s\n", str);

}



int main(int argc, char *argv[]) {

char str[10];

scanf("%s", str);


go_print( str );


return 0;
}
