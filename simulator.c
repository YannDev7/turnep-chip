#include<stdlib.h>
#include<stdio.h>
#include<stdint.h>
#include<inttypes.h>

uint64_t binaryToDecimal(uint64_t n){
	uint64_t num = n;
	uint64_t dec_value = 0;
	uint64_t base = 1;
	uint64_t temp = num;
	while (temp) {
		uint64_t last_digit = temp % 10;
		temp = temp / 10;
		dec_value += last_digit * base;
		base = base * 2;
	}
	return dec_value;
}
uint16_t stringToDecimal(char* c, int n){
	uint64_t res = 0;
	for(int i = n-1; i > -1; i --){
		res = 2*res + c[i] -'0';
	}
	return res;
}int expo(int n, int x){
	int res = x;
	for (int i = 1; i < n; i ++){
		res = res * x;
}
	return res;
	}
int main(void){
	for (uint64_t i = 0; i < 3; i = i + 1){
uint64_t v_1 = 0;
 int v_1_taille = 1;
uint64_t v_3 = 0;
 int v_3_taille = 2;
uint64_t v_5 = 0;
 int v_5_taille = 2;
uint64_t v_7 = ~v_5 & ((1<<v_5_taille)-1);
int v_7_taille = v_5_taille;
uint64_t v_9 = 1;
 int v_9_taille = 1;
		uint64_t v_11 = (v_3 & (1<<v_3_taille - 1 -1))>>(v_3_taille -1 -1);
		uint64_t v_11_taille = 1;
		uint64_t v_13 = (v_7 & (1<<v_7_taille - 1 -1))>>(v_7_taille -1 -1);
		uint64_t v_13_taille = 1;
		uint64_t v_15 = v_11 ^ v_13;
int v_15_taille = v_11_taille;
		uint64_t v_17 = v_15 ^ v_9;
int v_17_taille = v_15_taille;
		uint64_t v_19 = v_15 & v_9;
int v_19_taille = v_15_taille;
		uint64_t v_21 = v_11 & v_13;
int v_21_taille = v_11_taille;
		uint64_t v_23 = v_19 | v_21;
int v_23_taille = v_19_taille;
		uint64_t v_25 = (v_3 & (1<<v_3_taille - 0 -1))>>(v_3_taille -0 -1);
		uint64_t v_25_taille = 1;
		uint64_t v_27 = (v_7 & (1<<v_7_taille - 0 -1))>>(v_7_taille -0 -1);
		uint64_t v_27_taille = 1;
		uint64_t v_29 = v_25 ^ v_27;
int v_29_taille = v_25_taille;
		uint64_t v_31 = v_29 ^ v_23;
int v_31_taille = v_29_taille;
		uint64_t v_33 = v_29 & v_23;
int v_33_taille = v_29_taille;
		uint64_t v_35 = v_25 & v_27;
int v_35_taille = v_25_taille;
		uint64_t v_37 = v_33 | v_35;
int v_37_taille = v_33_taille;
		uint64_t v_39 = (v_31 << v_17_taille) + v_17;
		uint64_t v_39_taille = v_31_taille + v_17_taille;
		uint64_t v_41 = (v_37 << v_39_taille) + v_39;
		
		uint64_t v_41_taille = v_37_taille + v_39_taille;
		printf("%ld\n", v_41_taille);
		printf("%d\n",  4&(1<<v_41_taille) -1);
		printf("raah=%ld\n", (v_41 & ( (1<<v_41_taille) -1)) );
} 
 return 0;
 }