%{
  #include<stdio.h>
  #include<stdlib.h>
   void yyerror();
  #define YYDEBUG 1
  int yydebug= 1;   
  %}

%token VERSIONSTAMP 
%token UCODESTAMP 
%token DECCONST
%token COMMA
%token OCTCONST
%token IDENTIFIER
%token CONTROL_L
%token REALCONST
%token FILENAME
%token LABEL
%token  ANY
%token Op_Asgn	
%token Op_Bang	
%token Op_Cat	
%token Op_Compl	
%token Op_Diff	
%token Op_Div	
%token Op_Eqv	
%token Op_Inter	 
%token Op_Lconcat
%token Op_Lexeq	
%token Op_Lexge	
%token Op_Lexgt	
%token Op_Lexle	
%token Op_Lexlt	
%token Op_Lexne	
%token Op_Minus	
%token Op_Mod	
%token Op_Mult	
%token Op_Neg	
%token Op_Neqv	
%token Op_Nonnull
%token Op_Null	
%token Op_Number
%token Op_Numeq
%token Op_Numge
%token Op_Numgt
%token Op_Numle
%token Op_Numlt
%token Op_Numne
%token Op_Plus	
%token Op_Power
%token Op_Random
%token Op_Rasgn
%token Op_Rcv	
%token Op_Rcvbk
%token Op_Refresh
%token Op_Rswap
%token Op_Sect	
%token Op_Snd
%token Op_Sndbk
%token Op_Size	
%token Op_Subsc
%token Op_Swap	
%token Op_Tabmat
%token Op_Toby	
%token Op_Unions
%token Op_Value
%token Op_Bscan
%token Op_Ccase
%token Op_Chfail
%token Op_Coact 
%token Op_Cofail
%token Op_Coret 
%token Op_Create
%token Op_Cset  
%token Op_Dup   
%token Op_Efail 
%token Op_Einit 
%token Op_Eret  
%token Op_Escan 
%token Op_Esusp 
%token Op_Field 
%token Op_Goto  
%token Op_Init  
%token Op_Int   
%token Op_Invoke
%token Op_Keywd 
%token Op_Limit 
%token Op_Line  
%token Op_Llist 
%token Op_Lsusp 
%token Op_Mark  
%token Op_Pfail 
%token Op_Pnull 
%token Op_Pop   
%token Op_Pret  
%token Op_Psusp 
%token Op_Push1 
%token Op_Pushn1
%token Op_Real   
%token Op_Sdup   
%token Op_Str    
%token Op_Unmark 
%token Op_Var    
%token Op_Arg	
%token Op_Static
%token Op_Local	
%token Op_Global	
%token Op_Mark0	
%token Op_Quit		
%token Op_FQuit	
%token Op_Tally	
%token Op_Apply	
%token Op_Acset	
%token Op_Areal	
%token Op_Astr		
%token Op_Aglobal	
%token Op_Astatic	
%token Op_Agoto	
%token Op_Amark	
%token Op_Noop		
%token Op_Colm		
%token Op_Proc	
%token Op_Declend
%token Op_End		
%token Op_Link		
%token Op_Version	
%token Op_Con		
%token Op_Filen	
%token Op_Record	
%token Op_Impl		
%token Op_Error	
%token Op_Trace	
%token Op_Lab   	
%token Op_Invocable	
%token Op_Synt         
%token Op_Uid          
%token synt_stmt
%%
 
   prog:  u2 u1_multiple
        | u2
   ;
   
   u2:             Op_Version VERSIONSTAMP Op_Uid UCODESTAMP records op_impl links invocables global_lines CONTROL_L
   ;

   invocables:
                 | invocables invocable_line

   invocable_line: Op_Invocable IDENTIFIER
		 | Op_Invocable DECCONST
   ; 

   links:
                 | links link
   ; 

   link:           Op_Link IDENTIFIER
                 | Op_Link FILENAME
   ; 

   global_lines:   global_fline
                 | global_lines global_eline
     
   global_eline:   DECCONST COMMA OCTCONST COMMA IDENTIFIER COMMA DECCONST
     ;
   
   global_fline: Op_Global DECCONST
     ; 
   
   op_impl:     Op_Impl Op_Error
              | Op_Impl Op_Local
   ;

   records:    
              | records op_record
   ; 

   op_record:   Op_Record IDENTIFIER COMMA DECCONST
              | op_record record_line
   ; 

   record_line: DECCONST COMMA IDENTIFIER
              | DECCONST COMMA Op_Uid
              | DECCONST COMMA Op_Value
   ;

   u1_multiple: u1
              | u1_multiple u1

   u1:          u1_begin u1_end
   ;
   
   u1_begin:     proc_line u1_blines Op_Declend
              | proc_line Op_Declend
   ; 
   
   u1_blines:   u1_bline
              | u1_blines u1_bline
   ; 
 
   u1_bline:     local_line
               | con_line
   ; 
          
   proc_line:   Op_Proc IDENTIFIER
   ;
   
   local_line:   Op_Local DECCONST COMMA OCTCONST COMMA IDENTIFIER
               | Op_Local DECCONST COMMA OCTCONST COMMA op_codes
               | Op_Local DECCONST COMMA OCTCONST COMMA synt_stmt
               | Op_Local DECCONST COMMA OCTCONST COMMA Op_Proc
   ;
   
   con_line:    Op_Con DECCONST COMMA OCTCONST
              | con_line COMMA OCTCONST
              | con_line COMMA DECCONST
              | con_line COMMA REALCONST
     ;
 
   u1_end:      file_line u1_elines Op_End
              | file_line Op_End
              | u1_elines Op_End
     ;
 
   u1_elines:   u1_eline
              | u1_elines u1_eline
     ;

   file_line:  Op_Filen FILENAME
     ; 
 
    op_codes:   Op_Asgn
              | Op_Bang
              | Op_Cat
              | Op_Compl
              | Op_Diff
              | Op_Div
              | Op_Eqv
              | Op_Inter
              | Op_Lconcat
              | Op_Lexeq
              | Op_Lexge
              | Op_Lexgt
              | Op_Lexle
              | Op_Lexlt
              | Op_Lexne
              | Op_Minus
              | Op_Mod
              | Op_Mult
              | Op_Neg
              | Op_Neqv
              | Op_Nonnull
              | Op_Null
              | Op_Number
              | Op_Numeq
              | Op_Numge
              | Op_Numgt
              | Op_Numle
              | Op_Numlt
              | Op_Numne
              | Op_Plus
              | Op_Power
              | Op_Random
              | Op_Rasgn
              | Op_Rcv
              | Op_Rcvbk
              | Op_Refresh
              | Op_Rswap
              | Op_Sect
              | Op_Snd
              | Op_Sndbk
              | Op_Size
              | Op_Subsc
              | Op_Swap
              | Op_Tabmat
              | Op_Toby
              | Op_Unions
              | Op_Value
              | Op_Bscan
              | Op_Ccase
              | Op_Coact
              | Op_Cofail
              | Op_Coret
              | Op_Dup
              | Op_Efail
              | Op_Eret
              | Op_Escan
              | Op_Esusp
              | Op_Limit
              | Op_Lsusp
              | Op_Pfail
              | Op_Pnull
              | Op_Pop
              | Op_Pret
              | Op_Psusp
              | Op_Push1
              | Op_Pushn1
              | Op_Sdup
              | Op_Unmark
              | Op_Mark0
              | Op_Noop
              | Op_Colm
              | Op_Chfail
              | Op_Create
              | Op_Cset
              | Op_Einit
              | Op_Field
              | Op_Goto
              | Op_Init
              | Op_Int
              | Op_Line
              | Op_Llist
              | Op_Mark
              | Op_Real
              | Op_Str
              | Op_Keywd
              | Op_Synt
              | Op_Lab
              | Op_Var
              | Op_Invoke
   ;  
   
   u1_eline: Op_Asgn
              | Op_Bang
              | Op_Cat
              | Op_Compl
              | Op_Diff
              | Op_Div
              | Op_Eqv
              | Op_Inter
              | Op_Lconcat
              | Op_Lexeq
              | Op_Lexge
              | Op_Lexgt
              | Op_Lexle
              | Op_Lexlt
              | Op_Lexne
              | Op_Minus
              | Op_Mod
              | Op_Mult
              | Op_Neg
              | Op_Neqv
              | Op_Nonnull
              | Op_Null
              | Op_Number
              | Op_Numeq
              | Op_Numge
              | Op_Numgt
              | Op_Numle
              | Op_Numlt
              | Op_Numne
              | Op_Plus
              | Op_Power
              | Op_Random
              | Op_Rasgn
              | Op_Rcv
              | Op_Rcvbk
              | Op_Refresh
              | Op_Rswap
              | Op_Sect
              | Op_Snd
              | Op_Sndbk
              | Op_Size
              | Op_Subsc
              | Op_Swap
              | Op_Tabmat
              | Op_Toby
              | Op_Unions
              | Op_Value
              | Op_Bscan
              | Op_Ccase
              | Op_Coact
              | Op_Cofail
              | Op_Coret
              | Op_Dup
              | Op_Efail
              | Op_Eret
              | Op_Escan
              | Op_Esusp
              | Op_Limit
              | Op_Lsusp
              | Op_Pfail
              | Op_Pnull
              | Op_Pop
              | Op_Pret
              | Op_Psusp
              | Op_Push1
              | Op_Pushn1
              | Op_Sdup
              | Op_Unmark
              | Op_Mark0
              | Op_Noop
              | op_colm
              | op_chfail
              | op_create
              | op_cset
              | op_einit
              | op_field
              | op_goto
              | op_init
              | op_int
              | op_line
              | op_llist
              | op_mark
              | op_real
              | op_str
              | op_keywd
              | op_synt
              | op_lab
              | op_var
              | op_invoke
   ;
 op_lab:     Op_Lab LABEL
   ;
 op_colm:   Op_Colm DECCONST
     ; 
 op_synt:   Op_Synt synt_stmt
     ; 
 op_chfail: Op_Chfail LABEL
     ;
 op_create: Op_Create LABEL
     ;
 op_cset: Op_Cset DECCONST
     ;
 op_einit: Op_Einit LABEL
     ;
 op_field: Op_Field IDENTIFIER
          | Op_Field Op_Uid
          | Op_Field Op_Init
     ;
 op_goto: Op_Goto LABEL
     ;
 op_init: Op_Init LABEL
     ;
 op_int: Op_Int DECCONST
     ;
 op_line: Op_Line DECCONST
     ;
 op_llist: Op_Llist DECCONST
     ;
 op_mark: Op_Mark LABEL
     ;
 op_real: Op_Real DECCONST
     ;
 op_str: Op_Str DECCONST
     ;
 op_keywd: Op_Keywd IDENTIFIER
         | Op_Keywd Op_Error
         | Op_Keywd Op_Trace
         | Op_Keywd Op_Null
     ;
 op_var:   Op_Var DECCONST
     ;
 op_invoke:  Op_Invoke DECCONST
     ; 
           

%%

void yyerror(char const *s)
{
  fprintf (stderr, "%s\n", s);
}
/*
value      ?might be a field 
arg      not sure field? 
static   not sure field? 
vquit    ?field
fquit    ?field
tally    ?field
tally    ?local
apply    ?local
invocable    ?

*/ 
