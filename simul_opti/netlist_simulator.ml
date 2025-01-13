open Scheduler
open Netlist_ast
open Graph
let counter = ref 0 
let oc = open_out "simulator.c"
let print_only = ref false
let number_steps = ref (3)
let bool_of_int n = 
  not(n=0)
let int_of_bool s = 
  if s then 1 else 0

let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines 
let not_cal value = 
  match value with 
  |VBit(e) -> VBit(not(e))
  |VBitArray(elem) -> (let res = Array.make (Array.length elem) true in 
                       for i = 0 to (Array.length elem) -1 do 
                        res.(i) <- not( elem.(i))
                       done;
                       VBitArray(res)
                       )


let cal_ope oper arg1 arg2 = 
  match oper with 
  |Or -> (match arg1, arg2 with 
          |VBit(e1), VBit(e2) -> VBit(e1 || e2) 
          |VBitArray(ar1), VBitArray(ar2)-> if(( Array.length ar1) = (Array.length ar2) ) 
                                            then begin 
                                              let res = Array.make (Array.length ar1) true in 
                                              for i = 0 to Array.length ar1 -1 do 
                                                res.(i) <- ar1.(i) || ar2.(i)
                                              done;
                                              VBitArray(res)
                                            end 
                                            else failwith "pas les bonne tailles" 
            |_ -> failwith "Les deux types dans l'opération ne sont pas compatibles")
  |Xor ->  (match arg1, arg2 with 
            |VBit(e1), VBit(e2) -> VBit(e1 <> e2) 
            |VBitArray(ar1), VBitArray(ar2)-> if(( Array.length ar1) = (Array.length ar2) ) 
                                    then begin 
                                      let res = Array.make (Array.length ar1) true in 
                                      for i = 0 to Array.length ar1 -1 do 
                                        res.(i) <- ar1.(i) <> ar2.(i)
                                      done;
                                      VBitArray(res)
                                    end 
                                    else failwith "pas les bonne tailles" 
            |_ -> failwith "Les deux types dans l'opération ne sont pas compatibles")
  |And ->  (match arg1, arg2 with 
            |VBit(e1), VBit(e2) -> VBit(e1 && e2) 
            |VBitArray(ar1), VBitArray(ar2)-> if(( Array.length ar1) = (Array.length ar2) ) 
                                    then begin 
                                      let res = Array.make (Array.length ar1) true in 
                                      for i = 0 to Array.length ar1 -1 do 
                                        res.(i) <- ar1.(i) && ar2.(i)
                                      done;
                                      VBitArray(res)
                                    end 
                                    else failwith "pas les bonne tailles" 
            |_ -> failwith "Les deux types dans l'opération ne sont pas compatibles")
  |Nand ->  (match arg1, arg2 with 
            |VBit(e1), VBit(e2) -> VBit(not(e1 && e2)) 
            |VBitArray(ar1), VBitArray(ar2)-> if(( Array.length ar1) = (Array.length ar2) ) 
                                    then begin 
                                      let res = Array.make (Array.length ar1) true in 
                                      for i = 0 to Array.length ar1 -1 do 
                                        res.(i) <- not(ar1.(i) && ar2.(i))
                                      done;
                                      VBitArray(res)
                                    end 
                                    else failwith "pas les bonne tailles" 
            |_ -> failwith "Les deux types dans l'opération ne sont pas compatibles")
  

let concat arr1 arr2 = 
  let len1 = Array.length arr1 in 
  let len2 = Array.length arr2 in 
  let res = Array.make (len1 + len2) true in
  for i = 0 to len1 -1 do 
    res.(i) <- arr1.(i)
  done;
  for i = len1 to len1 + len2 -1 do 
    res.(i) <- arr2.(i-len1)
  done;
  res

let slice arr ind1 ind2 = 
  let res = Array.make (ind2 - ind1 + 1) true in 
  for i = ind1 to ind2 do 
    res.(i-ind1) <- arr.(i-1)
  done;
  res


let array_to_int arr= 
  let pow = ref 1 in 
  let res = ref 0 in 
  for i = Array.length arr -1 downto 0 do 
   res := !res + !pow*(int_of_bool arr.(i)); 
   pow := !pow*2
  
  done; 
  !res

let string_of_ope binop = 
  match binop with 
  |Or -> " | "
  |And -> " & "
  |Xor -> " ^ "
  |Nand -> ""

let int_of_value value = 
  match value with 
  |VBit(s) -> int_of_bool s
  |VBitArray(n) -> Array.fold_left (fun   i elem -> i*2 + (int_of_bool elem)) 0 n
let len_value value = 
  match  value with
  | VBit(_) -> 1
  | VBitArray(n) -> Array.length n

let find_vars vars var = 
  if Hashtbl.mem vars var then 
    Hashtbl.find vars var 
else (
  counter := !counter + 1;
  Printf.printf "%s = %d\n" var (!counter);
  Hashtbl.add vars var (!counter);
  counter := !counter + 1;
  Hashtbl.find vars var)

let deal_with_exp exp  types vars   = 
  let (name, eq) = exp in 
  

  match eq with 
  |Earg(elem) -> (match elem with 
                    |Avar(id) -> (Printf.fprintf oc "uint64_t v_%d = v_%d;\nint v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id) (find_vars vars name) (find_vars vars id))
                    |Aconst(value)-> (match value with 
                                      |VBit(s) -> Printf.fprintf oc "uint64_t v_%d = %d;\n int v_%d_taille = 1;\n"(find_vars vars name) (int_of_bool s) (find_vars vars name)
                                      |VBitArray(n)-> let acc = Array.fold_left (fun    i elem -> i*2 + (int_of_bool elem)) 0 n in Printf.fprintf oc "uint64_t v_%d = %d;\n int v_%d_taille = %d;\n" (find_vars vars name) acc (find_vars vars name) (Array.length n)) )
  |Enot(elem) -> (match  elem with
                | Aconst(value) -> (match value with 
                                      |VBit(s) -> Printf.fprintf oc "uint64_t v_%d = ~%d & 1;\nint v_%d_taille = 1;\n" (find_vars vars name) (int_of_bool s) (find_vars vars name)
                                      |VBitArray(n)-> let acc = Array.fold_left (fun   i elem -> i*2 + (int_of_bool elem)) 0 n in Printf.fprintf oc "uint64_t v_%d = ~%d & (((int64_t)1<<%d)-1);\nv_%d_taille = %d;\n " (find_vars vars name) acc (Array.length n) (find_vars vars name) (Array.length n))
                | Avar(id) ->  Printf.fprintf oc "uint64_t v_%d = ~v_%d & (((int64_t)1<<v_%d_taille)-1);\nint v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id) (find_vars vars id) (find_vars vars name) (find_vars vars id) )
  |Ebinop(ope, arg1, arg2) -> (match arg1, arg2 with 
                                | Avar(id1), Avar(id2) -> (match ope with 
                                                          | Nand -> Printf.fprintf oc "\t\tuint64_t v_%d = ~(v_%d&v_%d);int v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id1) (find_vars vars id2) (find_vars vars name) (find_vars vars id1) 
                                                          | _ -> Printf.fprintf oc "\t\tuint64_t v_%d = v_%d%sv_%d;\nint v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id1) (string_of_ope ope) (find_vars vars id2) (find_vars vars name) (find_vars vars id1) )
                                | Avar(id1), Aconst(val2) ->(match ope with 
                                                          | Nand -> Printf.fprintf oc "\t\tuint64_t v_%d = ~(v_%d&%d);\nint v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id1) (int_of_value val2) (find_vars vars name) (find_vars vars id1) 
                                                          | _ -> Printf.fprintf oc "\t\tuint64_t v_%d = v_%d%s%d;\nint v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars id1) (string_of_ope ope) (int_of_value val2) (find_vars vars name) (find_vars vars id1) )
                                | Aconst(val1), Avar(id1)-> (match ope with 
                                                          | Nand -> Printf.fprintf oc "\t\tuint64_t v_%d = ~(v_%d&%d);\nint v_%d_taille = v_%d_taille\n" (find_vars vars name) (find_vars vars id1) (int_of_value val1) (find_vars vars name) (find_vars vars id1) 
                                                          | _ -> Printf.fprintf oc "\t\tuint64_t v_%d = v_%d%s%d;\nint v_%d_taille = v_%d_taille\n" (find_vars vars name) (find_vars vars id1) (string_of_ope ope) (int_of_value val1) (find_vars vars name) (find_vars vars id1) )
                                |Aconst(val1), Aconst(val2) -> (let len = (match val1 with |VBit(s) -> 1 |VBitArray(n)-> Array.length n) in match ope with 
                                                          | Nand -> Printf.fprintf oc "\t\tuint64_t v_%d = ~(%d&%d);\n" (find_vars vars name) (int_of_value val1) (int_of_value val2)
                                                          | _ -> Printf.fprintf oc "\t\tuint64_t v_%d = %d%s%d;\nint v_%d_taille = %d\n" (find_vars vars name) (int_of_value val1) (string_of_ope ope) (int_of_value val2) (find_vars vars name) len)
                                  )
  | Emux (choice, arg1, arg2) -> (
                                  (*match choice with 
                                  |Avar(id) -> (Printf.fprintf oc "uint64_t v_%d; uint64_t v_%d_taille;\nif (v_%d){\n\t\t\t\t  v_%d = " (find_vars vars name) (find_vars vars name) (find_vars vars id) (find_vars vars name); 
                                                (match arg1 with
                                                  |Avar(id1) -> Printf.fprintf oc "v_%d;\n\t\t\t  v_%d_taille = v_%d_taille;\n}\n" (find_vars vars id1) (find_vars vars name) (find_vars vars id1) 
                                                  |Aconst(value) -> Printf.fprintf oc "%d;\n\t\t\ v_%d_taille = %d;\n}\n" (int_of_value value) (find_vars vars name) (len_value value) );
                                                Printf.fprintf oc "\t\t\telse{\n  v_%d = " (find_vars vars name);
                                                (match arg2 with
                                                  |Avar(id1) -> Printf.fprintf oc "v_%d;\n\t\t\t  v_%d_taille = v_%d_taille;\n}\n" (find_vars vars id1) (find_vars vars name) (find_vars vars id1) 
                                                  |Aconst(value) ->  Printf.fprintf oc "%d;\n\t\t\ v_%d_taille = %d;\n}\n" (int_of_value value) (find_vars vars name) (len_value value) )
                                                  )
                                  | Aconst(value) -> (Printf.fprintf oc "uint64_t v_%d;\n uint64_t v_%d_taille;\nif (%d){\n\t\t\t\t  v_%d = " (find_vars vars name) (find_vars vars name) (int_of_value value) (find_vars vars name); 
                                    (match arg1 with
                                      |Avar(id1) -> Printf.fprintf oc "v_%d;\n\t\t\t  v_%d_taille = v_%d_taille;\n}\n" (find_vars vars id1) (find_vars vars name) (find_vars vars id1) 
                                      |Aconst(value) -> Printf.fprintf oc "%d;\n\t\t\t  v_%d_taille = %d;\n}\n" (int_of_value value) (find_vars vars name) (len_value value));
                                    Printf.fprintf oc "\t\t\telse{\ v_%d =" (find_vars vars name);
                                    (match arg2 with
                                      |Avar(id1) -> Printf.fprintf oc "v_%d;\n\t\t\t  v_%d_taille = v_%d_taille;\n}\n" (find_vars vars id1) (find_vars vars name) (find_vars vars id1) 
                                      |Aconst(value) -> Printf.fprintf oc "%d;\n\t\t\t  v_%d_taille = %d;\n}\n" (int_of_value value) (find_vars vars name) (len_value value))
                                      )*)

    let get_val truc = match truc with
      | Avar (id) -> ("v_"^(string_of_int(find_vars vars id))), ("v_"^(string_of_int (find_vars vars id))^"_taille" )
      | Aconst (value) -> (string_of_int (int_of_value value)), (string_of_int(len_value value))
    in 
    let vc, szc = get_val choice in
    let v1, sz1 = get_val arg1 in 
    let v2, sz2 = get_val arg2 in 
    Printf.fprintf oc "uint64_t v_%d = quoicoumux(%s, %s, %s);\n" (find_vars vars name) vc v1 v2;
    Printf.fprintf oc "uint64_t v_%d_taille = %s;\n" (find_vars vars name) sz1;

  )
  |Econcat(arg1, arg2) -> (match arg1, arg2 with
                            |Avar(id1), Avar(id2) -> Printf.fprintf oc "\t\tuint64_t v_%d = (v_%d << v_%d_taille) + v_%d;\n\t\tuint64_t v_%d_taille = v_%d_taille + v_%d_taille;\n" (find_vars vars name) (find_vars vars id1) (find_vars vars id2) (find_vars vars id2) (find_vars vars name) (find_vars vars id1) (find_vars vars id2) 
                            | Avar(id1), Aconst(val1) -> Printf.fprintf oc "\t\tuint64_t v_%d = (v_%d << %d) + %d;\n\t\tuint64_t v_%d_taille = v_%d_taille + %d;\n" (find_vars vars name) (find_vars vars id1) (len_value val1) (int_of_value val1) (find_vars vars name) (find_vars vars id1) (len_value val1)
                            |Aconst(val1), Avar(id1) -> Printf.fprintf oc "\t\tuint64_t v_%d = (%d << v_%d_taille) + v_%d;\n\t\tuint64_t v_%d_taille = %d + v_%d_taille;\n" (find_vars vars name) (int_of_value val1) (find_vars vars id1)  (find_vars vars id1) (find_vars vars name) (len_value val1) (find_vars vars id1) 
                            | Aconst(val1), Aconst(val2 ) -> Printf.fprintf oc "\t\tuint64_t v_%d = (%d << %d) + %d; \n\t\tuint64_t v_%d_taille = %d + %d\n;" (find_vars vars name) (int_of_value val1) (len_value val2) (int_of_value val2) (find_vars vars name) (len_value val1) (len_value val2))
  |Eslice(ind1, ind2, arg) -> (match arg with 
                            |Avar(id) -> Printf.fprintf oc "\t\tuint64_t v_%d = (v_%d & (expo(v_%d_taille - %d,2) -1 )) >> (int64_t)((v_%d_taille-%d-1));\n\t\tuint64_t v_%d_taille = %d-%d+1;\n" (find_vars vars name) (find_vars vars id) (find_vars vars id) ind1 (find_vars vars id)  (ind2) (find_vars vars name) ind2 ind1
                            |Aconst(val1) -> Printf.fprintf oc "\t\tuint64_t v_%d = (%d & (expo(%d - %d,2)-1)) >> (int64_t)((%d -%d-1));\n\t\tuint64_t v_%d_taille = %d - %d + 1;\n" (find_vars vars name) (int_of_value val1) (len_value val1) ind1 (len_value val1) (ind2) (find_vars vars name) ind2 ind1 )
  |Eselect(ind, arg) -> (match  arg with
                        | Avar(id) -> Printf.fprintf oc "\t\tuint64_t v_%d = (v_%d & ((int64_t)1<<(v_%d_taille - %d -1)))>>(int64_t)(v_%d_taille -%d -1);\n\t\tuint64_t v_%d_taille = 1;\n" (find_vars vars name) (find_vars vars id) (find_vars vars id) ind (find_vars vars id) ind (find_vars vars name) 
                        |Aconst(val1) -> Printf.fprintf oc "\t\tuint64_t v_%d = (%d & ((int64_t)1<<(%d - %d -1)))>>(int64_t)(%d -%d -1);\n\t\tuint64_t v_%d_taille = 1;\n" (find_vars vars name) (int_of_value val1) (len_value val1) ind (len_value val1) ind (find_vars vars name)  )  
  |Ereg(x) -> (Printf.fprintf oc "\t\tuint64_t v_%d = v_%d_reg;\n\t\t uint64_t v_%d_taille = v_%d_taille;\n" (find_vars vars name) (find_vars vars x) (find_vars vars name) (find_vars vars x))
  | Eram(_,word_size,arg,_,_,_) -> (match arg with
                                            | Avar(x) -> Printf.fprintf oc "\t\tuint64_t v_%d = v_%d_ram[v_%d];\nuint64_t v_%d_taille = %d;\n" (find_vars vars name) (find_vars vars name) (find_vars vars x) (find_vars vars name) word_size
                                            | Aconst(value) -> Printf.fprintf oc "\t\tuint64_t v_%d =  v_%d_ram[%d];\nuint64_t v_%d_taille = %d;\n" (find_vars vars name) (find_vars vars name) (int_of_value value) (find_vars vars name) word_size)
  | Erom(_,word_size,arg) -> (match arg with
                                | Avar(x) -> Printf.fprintf oc "\t\t//Hello \nuint64_t v_%d = v_%d_rom[v_%d];\nuint64_t v_%d_taille = %d;\n" (find_vars vars name) (find_vars vars name) (find_vars vars x) (find_vars vars name) word_size
                                | Aconst(value) -> Printf.fprintf oc "\t\t//Hello\nuint64_t v_%d = v_%d_rom[%d];\nuint64_t v_%d_taille = %d;\n" (find_vars vars name) (find_vars vars name) (int_of_value value) (find_vars vars name) word_size)
let rec expo x n = 
  if n = 0 then 1 else
  x*(expo x (n-1))


let simulator program number_steps = 

  (*  Fast compile g++ -O3 -march=native -mtune=native -flto -ffast-math -funroll-loops simulator2.c -o simulator *)
  Printf.printf "here\n";
  Printf.fprintf oc "#include<stdlib.h>\n#include<stdio.h>\n#include<stdint.h>\n#include<inttypes.h>\n\n";
  Printf.fprintf oc "#pragma GCC optimize(\"O3,unroll-loops\")\n
#pragma GCC target(\"avx2,popcnt,lzcnt,abm,bmi,bmi2,sse4.2,fma,tune=native\")\n
#pragma GCC optimize(\"fast-math\")\n
#pragma GCC prefetch\n";

  Printf.fprintf oc "uint64_t binaryToDecimal(uint64_t n){\n\tuint64_t num = n;\n\tuint64_t dec_value = 0;\n\tuint64_t base = 1;\n\tuint64_t temp = num;\n\twhile (temp) {\n\t\tuint64_t last_digit = temp %% 10;\n\t\ttemp = temp / 10;\n\t\tdec_value += last_digit * base;\n\t\tbase = base * 2;\n\t}\n\treturn dec_value;\n}\n";
  Printf.fprintf oc "uint64_t stringToDecimal(char* c, int n){
	uint64_t res = 0;
	for(int i = 0; i < n; i ++){
		res = 2*res + c[i] -'0';
	}
	return res;
}";
  Printf.fprintf oc "uint64_t quoicoumux(uint64_t a, uint64_t b, uint64_t c) {
    if (a) return b;
	  return c;
  }";

  Printf.fprintf oc "void clear(){
	printf(\"\\033[H\\033[J\");
}";


  Printf.fprintf oc "int expo(int n, int x){\n\tint res = x;\n\tfor (int i = 1; i < n; i ++){\n\t\tres = res * x;\n}\n\treturn res;\n\t}\n";
  Printf.fprintf oc "int main(void){\n";
 let vars = Hashtbl.create 17 in 
  let types = program.p_vars in 
  let prog_order = schedule program in 
  List.iter(fun (name, elem) -> match elem with 
                          |Ereg(x) -> (let leng = (match Env.find x types with 
                                           |TBit ->1
                                           |TBitArray(len) -> len)
                                              in   
                                          Printf.fprintf oc "uint64_t v_%d_reg = 0;\nuint64_t v_%d_taille = %d;" (find_vars vars x) (find_vars vars x) leng)
                          |Erom(add_size,word_size, _) -> (Printf.fprintf oc "\tint v_%d_add_size = %d;\n\tuint64_t* v_%d_rom = (uint64_t*)malloc(expo(v_%d_add_size, 2)*sizeof(uint64_t));\n"(find_vars vars name) add_size  (find_vars vars name)  (find_vars vars name);
                                                         Printf.fprintf oc "\t FILE* f_%s = fopen(\"%s.db\", \"r\");\n\tchar buffer_%s[%d];\n" name name name word_size ;
                                                         Printf.fprintf oc "\tfor (int i = 0; i < expo(v_%d_add_size, 2); i++){\n\t\tfscanf(f_%s, \"%%s\\n\", buffer_%s); \n\t\tv_%d_rom[i] = stringToDecimal(buffer_%s, %d);\n\t}\n"  (find_vars vars name) name name  (find_vars vars name) name word_size)
 
                                                         
                          |Eram(add_size, word_size, _,_,_,_) -> (Printf.fprintf oc "\tint v_%d_add_size = %d;\n\tuint64_t* v_%d_ram = (uint64_t*)malloc(expo(v_%d_add_size, 2)*sizeof(uint64_t));\n" (find_vars vars name) add_size  (find_vars vars name)  (find_vars vars name);
                          Printf.fprintf oc "\tfor (int i = 0; i < expo(v_%d_add_size, 2); i++){ \n\t\tv_%d_ram[i] = 0;\n\t}\n"  (find_vars vars name) (find_vars vars name))

                                                                 
                          |_ -> ()) program.p_eqs;
  Printf.fprintf oc "\tfor (uint64_t i = 0; i < %d; i = i + 1){\n"  number_steps;
  
    List.iter (fun elem ->let length = 
                match (Env.find  elem types ) with 
                  |TBit -> 1
                  |TBitArray(len) -> len 
                  in 
                  Printf.fprintf oc "\t\tuint64_t v_%d;\n\t\tprintf(\"Donnder la valeur de %s qui a une longeur %d: \");\n\t\tscanf(\"%%ld\", &v_%d);\n \t\tv_%d = binaryToDecimal(v_%d); \n\t\tuint64_t v_%d_taille = %d;\n"(find_vars vars elem) elem length (find_vars vars elem) (find_vars vars elem) (find_vars vars elem) (find_vars vars elem) (length);
      ) prog_order.p_inputs;
    List.iter (fun exp -> deal_with_exp exp  types vars) prog_order.p_eqs;

    (*Mise a jour des rams*)
    List.iter (fun (name, elem) -> match elem with 
    |Eram (addr_size, word_size, _, we, wa, data) -> ((match we with 
                                                      |Avar(x) -> Printf.fprintf oc "if (v_%d){\n" (find_vars vars x) 
                                                      |Aconst(value) -> Printf.fprintf oc "if (%d){\n" (int_of_value value));
                                                      (match wa with 
                                                      |Avar(x) -> Printf.fprintf oc "uint64_t v_%d_wa = v_%d;\n" (find_vars vars name) (find_vars vars x)
                                                      |Aconst(value) -> Printf.fprintf oc "uint64_t v_%d_wa = %d;\n" (find_vars vars name) (int_of_value value));
                                                      (match data with
                                                      | Avar(x) -> Printf.fprintf oc "v_%d_ram[v_%d_wa] = v_%d;}\n" (find_vars vars name) (find_vars vars name)  (find_vars vars x)
                                                      | Aconst(value) -> Printf.fprintf oc "v_%d_ram[v_%d_wa] = %d;}\n" (find_vars vars name) (find_vars vars name) (int_of_value value)); )
    | _ -> ())  prog_order.p_eqs;
 (* print les res, mettre a jour les registres*)
    List.iter (fun id -> Printf.fprintf oc "\t\tprintf(\"%s=%%ld\\n\", v_%d );\n"  id (find_vars vars id) ) prog_order.p_outputs;
    List.iter (fun (name,elem) -> match elem with 
      |Ereg(x) -> Printf.fprintf oc "v_%d_reg = v_%d;\n" (find_vars vars x) (find_vars vars x) ;
      |_ -> ()) prog_order.p_eqs;
  Printf.fprintf oc "} \n return 0;\n }";
  
  close_out oc

let compile filename =
  try
    let p = Netlist.read_file filename in
    begin try
        let p = Scheduler.schedule p in
        simulator p !number_steps
      with
        | Scheduler.Combinational_cycle ->
            Format.eprintf "The netlist has a combinatory cycle.@.";
    end;
  with
    | Netlist.Parse_error s -> Format.eprintf "An error accurred: %s@." s; exit 2

let main () =
  Arg.parse
    ["-n", Arg.Set_int number_steps, "Number of steps to simulate"]
    compile
    ""
;;

main ()
