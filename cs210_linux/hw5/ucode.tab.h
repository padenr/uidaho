/* A Bison parser, made by GNU Bison 3.0.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_UCODE_TAB_H_INCLUDED
# define YY_YY_UCODE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VERSIONSTAMP = 258,
    UCODESTAMP = 259,
    DECCONST = 260,
    COMMA = 261,
    OCTCONST = 262,
    IDENTIFIER = 263,
    CONTROL_L = 264,
    REALCONST = 265,
    FILENAME = 266,
    LABEL = 267,
    ANY = 268,
    Op_Asgn = 269,
    Op_Bang = 270,
    Op_Cat = 271,
    Op_Compl = 272,
    Op_Diff = 273,
    Op_Div = 274,
    Op_Eqv = 275,
    Op_Inter = 276,
    Op_Lconcat = 277,
    Op_Lexeq = 278,
    Op_Lexge = 279,
    Op_Lexgt = 280,
    Op_Lexle = 281,
    Op_Lexlt = 282,
    Op_Lexne = 283,
    Op_Minus = 284,
    Op_Mod = 285,
    Op_Mult = 286,
    Op_Neg = 287,
    Op_Neqv = 288,
    Op_Nonnull = 289,
    Op_Null = 290,
    Op_Number = 291,
    Op_Numeq = 292,
    Op_Numge = 293,
    Op_Numgt = 294,
    Op_Numle = 295,
    Op_Numlt = 296,
    Op_Numne = 297,
    Op_Plus = 298,
    Op_Power = 299,
    Op_Random = 300,
    Op_Rasgn = 301,
    Op_Rcv = 302,
    Op_Rcvbk = 303,
    Op_Refresh = 304,
    Op_Rswap = 305,
    Op_Sect = 306,
    Op_Snd = 307,
    Op_Sndbk = 308,
    Op_Size = 309,
    Op_Subsc = 310,
    Op_Swap = 311,
    Op_Tabmat = 312,
    Op_Toby = 313,
    Op_Unions = 314,
    Op_Value = 315,
    Op_Bscan = 316,
    Op_Ccase = 317,
    Op_Chfail = 318,
    Op_Coact = 319,
    Op_Cofail = 320,
    Op_Coret = 321,
    Op_Create = 322,
    Op_Cset = 323,
    Op_Dup = 324,
    Op_Efail = 325,
    Op_Einit = 326,
    Op_Eret = 327,
    Op_Escan = 328,
    Op_Esusp = 329,
    Op_Field = 330,
    Op_Goto = 331,
    Op_Init = 332,
    Op_Int = 333,
    Op_Invoke = 334,
    Op_Keywd = 335,
    Op_Limit = 336,
    Op_Line = 337,
    Op_Llist = 338,
    Op_Lsusp = 339,
    Op_Mark = 340,
    Op_Pfail = 341,
    Op_Pnull = 342,
    Op_Pop = 343,
    Op_Pret = 344,
    Op_Psusp = 345,
    Op_Push1 = 346,
    Op_Pushn1 = 347,
    Op_Real = 348,
    Op_Sdup = 349,
    Op_Str = 350,
    Op_Unmark = 351,
    Op_Var = 352,
    Op_Arg = 353,
    Op_Static = 354,
    Op_Local = 355,
    Op_Global = 356,
    Op_Mark0 = 357,
    Op_Quit = 358,
    Op_FQuit = 359,
    Op_Tally = 360,
    Op_Apply = 361,
    Op_Acset = 362,
    Op_Areal = 363,
    Op_Astr = 364,
    Op_Aglobal = 365,
    Op_Astatic = 366,
    Op_Agoto = 367,
    Op_Amark = 368,
    Op_Noop = 369,
    Op_Colm = 370,
    Op_Proc = 371,
    Op_Declend = 372,
    Op_End = 373,
    Op_Link = 374,
    Op_Version = 375,
    Op_Con = 376,
    Op_Filen = 377,
    Op_Record = 378,
    Op_Impl = 379,
    Op_Error = 380,
    Op_Trace = 381,
    Op_Lab = 382,
    Op_Invocable = 383,
    Op_Synt = 384,
    Op_Uid = 385,
    synt_stmt = 386
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_UCODE_TAB_H_INCLUDED  */
