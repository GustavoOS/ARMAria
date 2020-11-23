int factorial(int numero){
    printf("%d", numero);
    if(numero<2){
        return 1;
    }else{
        return numero*factorial(numero-1);
    }
}

int main(void){
    char c;
    scanf(" %c", &c);
    printf("%d", factorial(c));
}

