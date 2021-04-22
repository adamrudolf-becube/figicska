program figipro;
uses crt;
                                    {1-5: �let
                                     6-10: csapda
                                     11:jobb als� sarok}
const szam=11;                      {T�rgyak (�letek �s lila csapd�k) sz�ma.}
type koord=record                   {T�rgyak t�pusa, x �s y koordin�ta.}
 x:byte;
 y:byte;
 end;
var
 ox,oy,xx,xy,kx,ky,i:byte;          {J�t�kosok koordin�t�i �s ciklusv�ltoz�.}
 x,o,k:smallint;                    {J�t�kosok �letei.}
 targyak: array[1..szam] of koord;  {A t�rgyak (�letek �s lila csapd�k) koordin�t�inak t�mbje.}
 j:byte;                            {2. ciklusv�ltoz�. Oda kell, ahol 2 for van egym�son bel�l.}
 scs:array[1..15] of koord;         {Spec. csapd�k koordin�t�i. 1-5:o 6-10:x 11-15:k.}
 cs,sc,kc:array[6..10] of integer;  {Azt vizsg�lja, hogy a j�t�kos r�l�pett-e az adott lila csapd�ra, vagy rajta �llt.}
 f,g,h:integer;                     {Azt vizsg�lja, hogy a j�t�kos a m�sikra l�pett-e, vagy rajta �ll.}
 c:char;                            {Az ir�ny�t�s ebben t�rol�dik.}
 onyert,xnyert,knyert:boolean;      {Igazz� v�lik, ha az adott j�t�kos nyert.}
 esc:boolean;                       {Igazz� v�lik, ha valaki esc-et nyom}
 ocs,xcs,kcs:byte;                  {Azt vizsg�lja, hogy hanyadik csapd�t rakja le az adott j�t�kos.}
 os:array[1..5] of integer;
 oc:array[1..5] of integer;         {Azt vizsg�lja, hogy az adott spec. csapd�ra l�pett-e a j�t�kos, vagy rajta �llt-e.}
 ok:array[1..5] of integer;
 fal1:boolean;
 ttab: array[0..99] of string;      {A men�h�z kell (az elemeit t�rolja)}
 jelzo:byte;                        {Ez is (azt jelzi, hogy melyik elem van kiv�lasztva)}
 gotoh:boolean;                     {Akkor van szerepe, mikor a program a kezd�sn�l vizsg�lja, hogy a t�rgyak nincsenek-e egym�son. a goto-t v�ltja fel}
 ir:array[1..15] of char;           {Az irany�t�s gombjait t�rolja}
 {1:fel, 2:balra, 3:jobbra, 4: le, 5:bomba, sorrend:o,x,k}
 r:byte;                            {random sz�m�t�shoz}
 sziv:byte;                         {azt sz�molja, hogy h�ny sz�v lett felv�ve}
 ogep,xgep,kgep:boolean;            {akkor igaz, ha az adott karaktert a g�p ir�ny�tja}
procedure tablazat(tszam:integer);  {A t�bl�zat (men�) kirajzol�sa}
  var
      jel:char;
  begin
    jelzo:=1;
    repeat
      for i:=0 to tszam do begin
        if i=jelzo then begin
          textcolor(11);
          writeln(ttab[i]);
        end
        else
          begin
          textcolor(3);
          writeln(ttab[i]);
          end;
      end;
      jel:=readkey;
      if jel=#72 then begin
       if jelzo>1 then jelzo:=jelzo-1
       else jelzo:=tszam;
      end;
      if jel=#80 then begin
       if jelzo<tszam then jelzo:=jelzo+1
       else jelzo:=1;
      end;
      clrscr;
      textcolor(11);
    until jel=#13;
  end;
function fal(x,y:byte;tomb:boolean;alfa,omega,a:byte;s:smallint):boolean;
{x,y:a l�p� f�l koordin�t�i. tomb:igaz, ha a targyak t�mb�t n�zi �s hamis,
ha az scs-t. alfa, omega: mett�l meddig vizsg�lja a t�mb elemeit
a:ir�ny. 1:fel.2:balra,3:le,4:jobbra, s:verzi�-. 1, ha k�tszem�lyes}
 begin
  fal:=false;
  if tomb=true then begin
   case a of
   1:begin
     for i:=alfa to omega do begin
      if (targyak[i].x=x) and (targyak[i].y=(y-1)) then fal:=true;                   
      if (s=1) and (y=3) and (targyak[i].x=x) and (targyak[i].y=25) then fal:=true;  //Ha a karakter a p�lya tetej�n van, a t�rgy meg a p�lya alj�n
      if (s<>1) and (y=4) and (targyak[i].x=x) and (targyak[i].y=25) then fal:=true;
     end;
   end;
   2:begin
     for i:=alfa to omega do begin
      if (targyak[i].y=y) and (targyak[i].x=(x-1)) then fal:=true;
      if (x=1) and (targyak[i].x=80) and (targyak[i].y=y) then fal:=true;
     end;
   end;
   3:begin
     for i:=alfa to omega do begin
      if (targyak[i].x=x) and (targyak[i].y=(y+1)) then fal:=true;
      if (s=1) and (y=25) and (targyak[i].x=x) and (targyak[i].y=3) then fal:=true;
      if (s<>1) and (y=25) and (targyak[i].x=x) and (targyak[i].y=4) then fal:=true;
     end;
   end;
   4:begin
     for i:=alfa to omega do begin
      if (targyak[i].y=y) and (targyak[i].x=(x+1)) then fal:=true;
      if (x=80) and (targyak[i].x=1) and (targyak[i].y=y) then fal:=true;
     end;
   end;
   end;
  end
  else begin
   case a of
   1:begin
     for i:=alfa to omega do begin
      if (scs[i].x=x) and (scs[i].y=(y-1)) then fal:=true;
      if (s=1) and (y=3) and (scs[i].x=x) and (scs[i].y=25) then fal:=true;
      if (s<>1) and (y=4) and (scs[i].x=x) and (scs[i].y=25) then fal:=true;
     end;
   end;
   2:begin
     for i:=alfa to omega do begin
      if (scs[i].y=y) and (scs[i].x=(x-1)) then fal:=true;
      if (x=1) and (scs[i].x=80) and (scs[i].y=y) then fal:=true;
     end;
   end;
   3:begin
     for i:=alfa to omega do begin
      if (scs[i].x=x) and (scs[i].y=(y+1)) then fal:=true;
      if (s=1) and (y=25) and (scs[i].x=x) and (scs[i].y=3) then fal:=true;
      if (s<>1) and (y=25) and (scs[i].x=x) and (scs[i].y=4) then fal:=true;
     end;
   end;
   4:begin
     for i:=alfa to omega do begin
      if (scs[i].y=y) and (scs[i].x=(x+1)) then fal:=true;
      if (x=80) and (scs[i].x=1) and (scs[i].y=y) then fal:=true;
     end;
   end;
   end;
  end;
 end;
procedure torolo;{o t�rl�se}
 begin
 gotoxy(ox,oy);
 write(' ');
 end;
procedure torolx;{x t�rl�se}
 begin
 gotoxy(xx,xy);
 write(' ');
 end;
procedure torolk;{k t�rl�se}
 begin
 gotoxy(kx,ky);
 write(' ');
 end;
procedure iro;{o ki�r�sa}
 begin
 gotoxy(ox,oy);
 textcolor(10);
 write('o');
 textcolor(11);
 end;
procedure irx;{x ki�r�sa}
 begin
 gotoxy(xx,xy);
 textcolor(9);
 write('x');
 textcolor(11);
 end;
procedure irk;{k ki�r�sa}
 begin
 gotoxy(kx,ky);
 textcolor(14);
 write(#4);
 textcolor(11);
 end;
procedure okap;{o �letet kap}
 begin
 o:=o+1;
 gotoxy(o,1);
 textcolor(10);
 write('o');
 textcolor(11);
 end;
procedure oveszt;{o �letet veszt}
 begin
 gotoxy(o,1);
 write(' ');
 o:=o-1;
 end;
procedure xkap;{x �letet kap}
 begin
 x:=x+1;
 gotoxy((75+x),1);
 textcolor(9);
 write('x');
 textcolor(11);
 end;
procedure xveszt;{x �letet veszt}
 begin
 gotoxy((75+x),1);
 write(' ');
 x:=x-1;
 end;
procedure kkap;{k �letet kap}
 begin
 k:=k+1;
 gotoxy((36+k),1);
 textcolor(14);
 write(#4);
 textcolor(11);
 end;
procedure kveszt;{k �letet veszt}
 begin
 gotoxy((36+k),1);
 write(' ');
 k:=k-1;
 end;
procedure ocsk;{o falat helyez el (h�rom szem�lyesben)}
 begin
 if ocs <>6 then begin
 gotoxy(scs[ocs].x,scs[ocs].y);
 write(' ');
 scs[ocs].x:=ox;
 scs[ocs].y:=oy;
 gotoxy(scs[ocs].x,scs[ocs].y);
 ocs:=ocs+1;
 end;
 end;
procedure xcsk;{x falat helyez el (h�rom szem�lyesben)}
 begin
 if xcs <>11 then begin
 gotoxy(scs[xcs].x,scs[xcs].y);
 write(' ');
 scs[xcs].x:=xx;
 scs[xcs].y:=xy;
 gotoxy(scs[xcs].x,scs[xcs].y);
 xcs:=xcs+1;
 end;
 end;
procedure kcsk;{k falat helyez el (h�rom szem�lyesben)}
 begin
 if kcs <>16 then begin
 gotoxy(scs[kcs].x,scs[kcs].y);
 write(' ');
 scs[kcs].x:=kx;
 scs[kcs].y:=ky;
 gotoxy(scs[kcs].x,scs[kcs].y);
 kcs:=kcs+1;
 end;
 end;
procedure fel(b:char;s:smallint); {Fell�p�s az MI-hez. b a karakter, aki l�p, s pedig 1, ha 2 szem�lyes a verzi� (mert m�s a p�lya m�rete}
 begin
 case b of
 'o':begin
    if (fal(ox,oy,true,6,11,1,s)=true) or (fal(ox,oy,false,6,15,1,s)=true) then
    else begin
     if s=1 then begin
      if (ox=80) and (oy=3) then oy:=24
      else begin
       if oy=3 then oy:=25
       else oy:=oy-1;
      end;
     end
     else begin
      if (ox=80) and (oy=4) then oy:=24
      else begin
       if oy=4 then oy:=25
       else oy:=oy-1;
      end;
     end;
    end;
 end;
 'x':begin
    if (fal(xx,xy,true,6,11,1,s)=true) or (fal(xx,xy,false,1,5,1,s)=true) or (fal(xx,xy,false,11,15,1,s)=true) then
    else begin
     if s=1 then begin
      if (xx=80) and (xy=3) then xy:=24
      else begin
       if xy=3 then xy:=25
       else xy:=xy-1;
      end;
     end
     else begin
      if (xx=80) and (xy=4) then xy:=24
      else begin
       if xy=4 then xy:=25
       else xy:=xy-1;
      end;
     end;
    end;
 end;
 'k':begin
    if (fal(kx,ky,true,6,11,1,s)=true) or (fal(kx,ky,false,1,10,1,s)=true) then
    else begin
     if s=1 then begin
      if (kx=80) and (ky=3) then ky:=24
      else begin
       if ky=3 then ky:=25
       else ky:=ky-1;
      end;
     end
     else begin
      if (kx=80) and (ky=4) then ky:=24
      else begin
       if ky=4 then ky:=25
       else ky:=ky-1;
      end;
     end;
    end;
 end;
 end;
 end;
procedure jobbra(b:char;s:smallint); {MI-hez jobbra l�p�s. B: melyik karaktert l�ptesse}
 begin
 case b of
 'o':begin
    if (fal(ox,oy,true,6,11,4,s)=true) or (fal(ox,oy,false,6,15,4,s)=true) then fel(b,s)
    else begin
     if (ox=79) and (oy=25) then ox:=1
     else begin
      if ox=80 then ox:=1
      else ox:=ox+1;
     end;
    end;
 end;
 'x':begin
    if (fal(xx,xy,true,6,11,4,s)=true) or (fal(xx,xy,false,1,5,4,s)=true) or (fal(xx,xy,false,11,15,4,s)=true) then fel(b,s)
    else begin
     if (xx=79) and (xy=25) then xx:=1
     else begin
      if xx=80 then xx:=1
      else xx:=xx+1;
     end;
    end;
 end;
 'k':begin
    if (fal(kx,ky,true,6,11,4,s)=true) or (fal(kx,ky,false,1,10,4,s)=true) then fel(b,s)
    else begin
     if (kx=79) and (ky=25) then kx:=1
     else begin
      if kx=80 then kx:=1
      else kx:=kx+1;
     end;
    end;
 end;
 end;
 end;
procedure le(b:char;s:smallint); {Lel�p�s MI-hez. Param�terek: l�sd fell�p�s}
 begin
 case b of
 'o':begin
    if (fal(ox,oy,true,6,11,3,s)=true) or (fal(ox,oy,false,6,15,3,s)=true) then jobbra(b,s)
    else begin
     if s=1 then begin
      if (ox=80) and (oy=24) then oy:=3
      else begin
       if oy=25 then oy:=3
       else oy:=oy+1;
      end;
     end
     else begin
      if (ox=80) and (oy=24) then oy:=4
      else begin
       if oy=25 then oy:=4
       else oy:=oy+1;
      end;
     end;
    end;
 end;
 'x':begin
    if (fal(xx,xy,true,6,11,3,s)=true) or (fal(xx,xy,false,1,5,3,s)=true) or (fal(xx,xy,false,11,15,3,s)=true) then fel(b,s)
    else begin
     if s=1 then begin
      if (xx=80) and (xy=24) then xy:=3
      else begin
       if xy=25 then xy:=3
       else xy:=xy+1;
      end;
     end
     else begin
      if (xx=80) and (xy=24) then xy:=4
      else begin
       if xy=25 then xy:=4
       else xy:=xy+1;
      end;
     end;
    end;
 end;
 'k':begin
    if (fal(kx,ky,true,6,11,3,s)=true) or (fal(kx,ky,false,1,10,3,s)=true) then jobbra(b,s)
    else begin
     if s=1 then begin
      if (kx=80) and (ky=24) then ky:=3
      else begin
       if ky=25 then ky:=3
       else ky:=ky+1;
      end;
     end
     else begin
      if (ky=80) and (ky=24) then ky:=4
      else begin
       if ky=25 then ky:=4
       else ky:=ky+1;
      end;
     end;
    end;
 end;
 end;
 end;
procedure balra(b:char;s:smallint); {MI-hez balra l�p�s. b:melyik karaktert mozgatja}
 begin
 case b of
 'o':begin
    if (fal(ox,oy,true,6,11,2,s)=true) or (fal(ox,oy,false,6,15,2,s)=true) then le(b,s)
    else begin
     if (ox=1) and (oy=25) then ox:=79
     else begin
      if ox=1 then ox:=80
      else ox:=ox-1;
     end;
    end;
 end;
 'x':begin
    if (fal(xx,xy,true,6,11,2,s)=true) or (fal(xx,xy,false,1,5,2,s)=true) or (fal(xx,xy,false,11,15,2,s)=true) then le(b,s)
    else begin
     if (xx=1) and (xy=25) then xx:=79
     else begin
      if xx=1 then xx:=80
      else xx:=xx-1;
     end;
    end;
 end;
 'k':begin
    if (fal(kx,ky,true,6,11,2,s)=true) or (fal(kx,ky,false,1,10,2,s)=true) then le(b,s)
    else begin
     if (kx=1) and (ky=25) then kx:=79
     else begin
      if kx=1 then kx:=80
      else kx:=kx-1;
     end;
    end;
 end;
 end;
 end;
 
function tav(ax,ay,bx,by:byte):byte;
{az ax,ay �s bx,by koordin�t�j� pontok t�vols�g�t adja vissza}
 var x,y:byte;
 begin
  if ax>bx then x:=ax-bx
  else x:=bx-ax;
  if x>40 then x:=80-x;
  if ay>by then y:=ay-by
  else y:=by-ay;
  tav:=x+y;
 end;
 
procedure mik(b:char;s:smallint;mx,my:byte; var ux,uy:byte);
{Mesters�ges Intelligencia K�zeled�sre.
A b param�ter az a j�t�kos bet�je, akit az MI mozgat. S=1, ha 2 szem�lyes a verzi�
ux,uy: az �ld�z� koordin�t�inak v�ltoz�i, mx,my: a menek�l� k. v�ltoz�i}
 var f,v:byte; {f:1=f�l�tte,2=egy sor,3=alatta;v:1=balra,2=egy oszlop,3=jobbra}
     r:byte;
 begin
  {V�zszintes vizsg�lat:v esetei: 3:jobbra 2:semerre 1:balra �rdemes menni}
  if ux=mx then v:=2
  else begin
   if ux<40 then begin
    if (ux<mx) and (mx<ux+40) then v:=3
    else v:=1;
   end
   else begin
    if (ux>mx) and (mx>ux-40) then v:=1
    else v:=3;
   end;
  end;
  {F�gg�leges vizsg�lat:f esetei:1:fel 2:semerre 3: lefele �rdemesebb menni}
  if uy=my then f:=2
  else begin
   if uy<14 then begin
    if (uy<my) and (my<uy+12) then f:=3
    else f:=1;
   end
   else begin
    if (uy>my) and (my>uy-12) then f:=1
    else f:=3;
   end;
  end;
  gotoxy(ux,uy);
  write(' ');
  r:=random(2);
  case v of
  1:begin
    case f of
    1:begin
      if r=1 then fel(b,s)
      else balra(b,s);
    end;
    2:balra(b,s);
    3:begin
      if r=1 then le(b,s)
      else balra(b,s);
    end;
    end;
  end;
  2:begin
    case f of
    1:fel(b,s);
    2:balra(b,s);
    3:le(b,s);
    end;
  end;
  3:begin
    case f of
    1:begin
      if r=1 then fel(b,s)
      else jobbra(b,s);
    end;
    2:jobbra(b,s);
    3:begin
      if r=1 then le(b,s)
      else jobbra(b,s);
    end;
    end;
  end;
  end;
 end;
procedure mit(b:char;s:smallint;mx,my:byte; var ux,uy:byte);
{Mesters�ges Intelligencia T�volod�sra.
A b param�ter az a j�t�kos bet�je, akit az MI mozgat. S=1, ha 2 szem�lyes a verzi�
ux,uy: az intelligens koordin�t�inak v�ltoz�i, mx,my: az �ld�z� k. v�ltoz�i}
 var f,v:byte; {f:1=f�l�tte,2=egy sor,3=alatta;v:1=balra,2=egy oszlop,3=jobbra}
     r:byte;
 begin
  {V�zszintes vizsg�lat:v esetei: 3:jobbra 2:semerre 1:balra �rdemes menni}
  if ux=mx then v:=2
  else begin
   if ux<40 then begin
    if (ux<mx) and (mx<ux+40) then v:=3
    else v:=1;
   end
   else begin
    if (ux>mx) and (mx>ux-40) then v:=1
    else v:=3;
   end;
  end;
  {F�gg�leges vizsg�lat:f esetei:1:fel 2:semerre 3: lefele �rdemesebb menni}
  if uy=my then f:=2
  else begin
   if uy<14 then begin
    if (uy<my) and (my<uy+12) then f:=3
    else f:=1;
   end
   else begin
    if (uy>my) and (my>uy-12) then f:=1
    else f:=3;
   end;
  end;
  gotoxy(ux,uy);
  write(' ');
  r:=random(2);
  case v of
  1:begin
    case f of
    1:begin
      if r=1 then le(b,s)
      else jobbra(b,s);
    end;
    2:begin
      if r=1 then fel(b,s)
      else le(b,s);
    end;
    3:begin
      if r=1 then fel(b,s)
      else jobbra(b,s);
    end;
    end;
  end;
  2:begin
    case f of
    1:begin
      if r=1 then jobbra(b,s)
      else balra(b,s);
    end;
    2:jobbra(b,s);
    3:begin
      if r=1 then jobbra(b,s)
      else balra(b,s);
    end;
    end;
  end;
  3:begin
    case f of
    1:begin
      if r=1 then le(b,s)
      else balra(b,s);
    end;
    2:begin
      if r=1 then fel(b,s)
      else le(b,s);
    end;
    3:begin
      if r=1 then fel(b,s)
      else balra(b,s);
    end;
    end;
  end;
  end;
 end;
procedure mi(b:char;ux,uy,mx,my:byte;s:smallint; var x,y:byte);
{b:a karakter bet�je. ux,uy:az �t �ld�z� koordin�t�i. mx,my: az el�le
menek�l� koordin�t�i,s a verzi�sz�m, 1 ha 2 szem�lyes, x,y:az ir�ny�tott
f�l koordin�t�i}
 var min,sorsz:byte;
 begin
  if (b='x') and (s=1) then begin //x ir�ny�t�sa a k�tszem�lyes verzi�ban   
   if tav(x,y,ux,uy)<15 then mit(b,s,ux,uy,x,y)
   else begin
    if sziv<5 then begin
     min:=tav(x,y,targyak[1].x,targyak[1].y);
     sorsz:=1;
     for i:=1 to 5 do begin
      if tav(x,y,targyak[i].x,targyak[i].y)<min then begin
       min:=tav(x,y,targyak[i].x,targyak[i].y);
       sorsz:=i;
      end;
     end;
     gotoxy(1,25);
     write(min,' ');
     mik(b,s,targyak[sorsz].x,targyak[sorsz].y,x,y);
    end
    else mit(b,s,ux,uy,x,y);
   end;
  end
  else begin  //�sszes t�bbi eset
   if tav(x,y,ux,uy)>15 then begin
    if tav(x,y,mx,my)>23 then begin
     if sziv<5 then begin
      min:=tav(x,y,targyak[1].x,targyak[1].y);
      sorsz:=1;
      for i:=1 to 5 do begin
       if tav(x,y,targyak[i].x,targyak[i].y)<min then begin
        min:=tav(x,y,targyak[i].x,targyak[i].y);
        sorsz:=i;
       end;
      end;
      gotoxy(1,25);
      write(min,' ');
      mik(b,s,targyak[sorsz].x,targyak[sorsz].y,x,y);
     end
     else mik(b,s,mx,my,x,y);
    end
    else mik(b,s,mx,my,x,y);
   end
   else mit(b,s,ux,uy,x,y);
  end;
 end;
{---Innent�l a 2 szem�lyes verzi� elj�r�sai, hogyha m�s, mint a 3 szem�lyesben---}
procedure okap2; {o �letet kap}
 begin
 o:=o+1;
 gotoxy(o,1);
 textcolor(10);
 write('o');
 textcolor(15);
 end;
procedure oveszt2; {o �letet vesz�t}
 begin
 gotoxy(o,1);
 write(' ');
 o:=o-1;
 end;
procedure xkap2; {x �letet kap}
 begin
 x:=x+1;
 gotoxy((81-x),1);
 textcolor(9);
 write('x');
 textcolor(15);
 end;
procedure xveszt2; {x �letet vesz�t}
 begin
 gotoxy((81-x),1);
 write(' ');
 x:=x-1;
 end;
procedure ocsk2; {o speci�lis csapd�t helyez el}
 begin
 if ocs <>6 then begin
 gotoxy(scs[ocs].x,scs[ocs].y);
 write(' ');
 scs[ocs].x:=ox;
 scs[ocs].y:=oy;
 gotoxy(scs[ocs].x,scs[ocs].y);
 textcolor(2);
 write(#15);
 textcolor(15);
 ocs:=ocs+1;
 end;
 end;
procedure xcsk2; {x speci�lis csapd�t helyez el}
 begin
 if xcs <>5 then begin
 gotoxy(scs[xcs].x,scs[xcs].y);
 write(' ');
 scs[xcs].x:=xx;
 scs[xcs].y:=xy;
 gotoxy(scs[xcs].x,scs[xcs].y);
 textcolor(1);
 write(#15);
 textcolor(15);
 xcs:=xcs-1;
 end;
 end;
BEGIN
 randomize;
 targyak[11].x:=80;
 targyak[11].y:=25;
 ir[1]:=#119;
 ir[2]:=#97;
 ir[3]:=#100;
 ir[4]:=#115;
 ir[5]:=#9;
 ir[6]:=#56;
 ir[7]:=#52;
 ir[8]:=#54;
 ir[9]:=#53;
 ir[10]:=#48;
 ir[11]:=#139;
 ir[12]:=#130;
 ir[13]:=#251;
 ir[14]:=#160;
 ir[15]:=#109;  
 REPEAT {A j�t�k v�gezt�vel l�p ide vissza}
 clrscr;
 ttab[0]:='FigiPro';
 ttab[1]:='Ketszemelyes FigiPro inditasa';
 ttab[2]:='Haromszemelyes FigiPro inditasa';
 ttab[3]:='Beallitasok';
 ttab[4]:='Kilepes';
 tablazat(4);
 case jelzo of
 1:begin
 {---ITT KEZD�DIK A K�TSZEM�LYES VERZI�---}
 ttab[1]:='Ket jatekos';
 ttab[2]:='Egy jatekos: O';
 ttab[3]:='Egy jatekos: X';
 ttab[4]:='Jatekos nelkul (ket gep)';
 tablazat(4);
 gotoxy(1,1);     {�letek ki�r�sa a kezd� helyre}
 textcolor(10);
 write('o');
 gotoxy(80,1);
 textcolor(9);
 write('x');
 textcolor(15);
 gotoxy(1,2);
 for i:=1 to 80 do  {szeg�ly kirajzol�sa}
  write(#196);
 gotoh:=true;       {v�letlenszer� koordin�t�kat sorsol a t�rgyaknak, ha pedig k�t t�rgy ugyanoda ker�l, vagy egy j�t�kos hely�re ker�l, akkor �jat sorsol az �sszesnek}
 repeat
  for i:=1 to szam do begin
   targyak[i].x:=random(78)+2;
   targyak[i].y:=random(22)+3;
   for j:=1 to (i-1) do begin
    if (targyak[i].x=targyak[j].x) and (targyak[i].y=targyak[j].y) then
    gotoh:=false;
   end;
  end;
 until gotoh=true;
 for i:=1 to 5 do begin {o speci�lis csapd�inak kirak�sa a kezd� helyre}
  scs[i].x:=(i+34);
  scs[i].y:=1;
  gotoxy(scs[i].x,scs[i].y);
  textcolor(2);
  write(#15);
  textcolor(15);
 end;
 for i:=6 to 10 do begin {x speci�lis csapd�inak kirak�sa a kezd� helyre}
  scs[i].x:=(i+36);
  scs[i].y:=1;
  gotoxy(scs[i].x,scs[i].y);
  textcolor(1);
  write(#15);
  textcolor(15);
 end;
 for i:=1 to 5 do begin {�letek kirajzol�sa}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(12);
  write(#3);
  textcolor(15);
 end;
 onyert:=false;    {v�ltoz�k kezd��rt�keinek be�ll�t�sai}
 xnyert:=false;
 esc:=false;
 o:=1;
 x:=1;
 ox:=20;
 oy:=13;
 xx:=60;
 xy:=13;
 kx:=100;
 ky:=45;
 ocs:=1;
 xcs:=10;
 f:=1;
 for i:=1 to 5 do begin
  oc[i]:=1;
  os[i]:=1;
 end;
 for i:=6 to 10 do begin
  cs[i]:=1;
  sc[i]:=1;
 end;
 iro;
 irx;
 for i:=6 to 10 do begin {minden ciklusban �jra kirajzolja a csapd�kat}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
 end;
 delay(500); {v�r egy f�l m�sodpercet, hogy a j�t�kosok fel tudjanak k�sz�lni}
 REPEAT      {ez a nagy ciklus ism�tl�dik addig, am�g valaki nem nyer}
  for i:=6 to 10 do begin {minden ciklusban �jra kirajzolja a csapd�kat}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
  end;
  iro; {i�rja x-et �s o-t}
  irx;
  for i:=1 to 5 do begin      {o speci�lis csapd�it �rja ki}
   gotoxy(scs[i].x,scs[i].y);
   textcolor(2);
   write(#15);
   textcolor(15);
  end;
  for i:=6 to 10 do begin     {x speci�lis csapd�it �rja ki}
   gotoxy(scs[i].x,scs[i].y);
   textcolor(1);
   write(#15);
   textcolor(15);
  end;              {ir�ny�t�s}
  gotoxy(1,23);
  write(sziv);
  gotoxy(1,24);
  write(tav(ox,oy,xx,xy),' ');
  case jelzo of
  1:begin
  c:=readkey;
  case c of
   ir[1]:begin
          torolo;
          if (ox=80) and (oy=3) then oy:=24
          else begin
           if oy=3 then oy:=25
           else oy:=oy-1;
          end;
          iro;
         end;
   ir[2]:begin
       torolo;
       if (ox=1) and (oy=25) then ox:=79
       else begin
        if ox=1 then ox:=80
        else ox:=ox-1;
       end;
       iro;
       end;
   ir[4]:begin
       torolo;
       if (ox=80) and (oy=24) then oy:=3
       else begin
        if oy=25 then oy:=3
        else oy:=oy+1;
       end;
       iro;
       end;
   ir[3]:begin
       torolo;
       if (ox=79) and (oy=25) then ox:=1
       else begin
        if ox=80 then ox:=1
        else ox:=ox+1;
       end;
       iro;
       end;
    ir[5]:ocsk2;
   ir[6]:begin
       torolx;
       if (xx=80) and (xy=3) then xy:=24
       else begin
        if xy=3 then xy:=25
        else xy:=xy-1;
       end;
       irx;
       end;
   ir[7]:begin
       torolx;
       if (xx=1) and (xy=25) then xx:=79
       else begin
        if xx=1 then xx:=80
        else xx:=xx-1;
       end;
       irx;
       end;
   ir[9]:begin
       torolx;
       if (xx=80) and (xy=24) then xy:=3
       else begin
        if xy=25 then xy:=3
        else xy:=xy+1;
       end;
       irx;
       end;
   ir[8]:begin
       torolx;
       if (xx=79) and (xy=25) then xx:=1
       else begin
        if xx=80 then xx:=1
        else xx:=xx+1;
       end;
       irx;
       end;
   ir[9]:xcsk2;
   #27:esc:=true;
  end;
  end;
  2:begin
  if keypressed then begin
  c:=readkey;
  case c of
   ir[1]:begin
       torolo;
       if (ox=80) and (oy=3) then oy:=24
       else begin
        if oy=3 then oy:=25
        else oy:=oy-1;
       end;
       iro;
       end;
   ir[2]:begin
       torolo;
       if (ox=1) and (oy=25) then ox:=79
       else begin
        if ox=1 then ox:=80
        else ox:=ox-1;
       end;
       iro;
       end;
   ir[4]:begin
       torolo;
       if (ox=80) and (oy=24) then oy:=3
       else begin
        if oy=25 then oy:=3
        else oy:=oy+1;
       end;
       iro;
       end;
   ir[3]:begin
       torolo;
       if (ox=79) and (oy=25) then ox:=1
       else begin
        if ox=80 then ox:=1
        else ox:=ox+1;
       end;
       iro;
       end;
    ir[5]:ocsk2;
   #27:esc:=true;
  end;
  end;
  r:=random(50);
  if r=0 then mi('x',ox,oy,kx,ky,1,xx,xy);
  end;
  3:begin
  if keypressed then begin
  c:=readkey;
  case c of
   ir[6]:begin
       torolx;
       if (xx=80) and (xy=3) then xy:=24
       else begin
        if xy=3 then xy:=25
        else xy:=xy-1;
       end;
       irx;
       end;
   ir[7]:begin
       torolx;
       if (xx=1) and (xy=25) then xx:=79
       else begin
        if xx=1 then xx:=80
        else xx:=xx-1;
       end;
       irx;
       end;
   ir[9]:begin
       torolx;
       if (xx=80) and (xy=24) then xy:=3
       else begin
        if xy=25 then xy:=3
        else xy:=xy+1;
       end;
       irx;
       end;
   ir[8]:begin
       torolx;
       if (xx=79) and (xy=25) then xx:=1
       else begin
        if xx=80 then xx:=1
        else xx:=xx+1;
       end;
       irx;
       end;
   ir[9]:xcsk2;
   #27:esc:=true;
  end;
  end;
  r:=random(50);
  if r=0 then mi('o',kx,ky,xx,xy,1,ox,oy);
  end;
  4:begin
  if keypressed then begin
  c:=readkey;
  if c=#27 then halt;
  end;
  r:=random(50);
  if r=0 then mi('x',ox,oy,kx,ky,1,xx,xy);
  r:=random(50);
  if r=0 then mi('o',kx,ky,xx,xy,1,ox,oy);
  end;
  end;
 for i:=1 to 5 do begin {ha x �letre l�p, �letet kap}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   xkap2;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin {ha o �letre l�p, o �letet kap}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   okap2;
   sziv:=sziv+1;
   end;
  end;
 for i:=6 to 10 do begin {ha x csapd�ra l�p, �letet vesz�t}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   if cs[i]=1 then begin
    xveszt2;
    cs[i]:=cs[i]+1;
   end;
  end else
  cs[i]:=1
 end;
 for i:=6 to 10 do begin {ha o csapd�ra l�p, �letet vesz�t}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   if sc[i]=1 then begin
    oveszt2;
    sc[i]:=sc[i]+1;
   end;
  end else
  sc[i]:=1
 end;
 for i:=1 to 5 do begin {ha x o speci�lis csapd�j�ra l�p, �letet vesz�t}
  if (xx=scs[i].x) and (xy=scs[i].y) then begin
   if os[i]=1 then begin
    xveszt2;
    os[i]:=os[i]+1;
   end;
  end else
  os[i]:=1
 end;
 for i:=6 to 10 do begin {ha o x speci�lis csapd�j�ra l�p, �letet vesz�t}
  if (ox=scs[i].x) and (oy=scs[i].y) then begin
   if oc[i]=1 then begin
    oveszt2;
    oc[i]:=oc[i]+1;
   end;
  end else
  oc[i]:=1
 end;
 if (xx=ox) and (xy=oy) then begin {ha x �s o egy helyen �lnak, x �letet vesz�t}
  if f=1 then begin
   xveszt2;
   f:=f+1;
   end;
  end
  else
   f:=1;
 if (x<=0) then onyert:=true; {ha x-nek elfogy az �lete, vesz�t}
 if (o<=0) then xnyert:=true; {ha o-nak elfogy az �lete, vesz�t}
 until (onyert=true) or (xnyert=true) or (esc=true); {a nagy REPEAT ciklus v�ge}
 clrscr;
 gotoxy(16,12);       {a gy�ztes kihirdet�se}
 textcolor(11);
 if onyert=true then begin
  write('Nyertel, kedves ');
  textcolor(10);
  write('O');
  textcolor(11);
  write('! Nagyon �gyes vagy! Gratulalok!');
 end;
 if xnyert=true then begin
  write('Nyertel, kedves ');
  textcolor(9);
  write('X');
  textcolor(11);
  write('! Leraztad a kocsogot! Gratulalok!');
 end;
 if esc=false then begin
  repeat
   c:=readkey;
  until c=#13;
 end;
 {---ITT VAN V�GE A K�TSZEM�LYES VERZI�NAK---}
 end;
 2: begin
 {---INNENT�L 3 SZEM�LYES---}
  ogep:=false;
  xgep:=false;
  kgep:=false;
 repeat
  ttab[0]:='Jatekosok beallitasa';
  ttab[1]:='O';
  ttab[2]:=#04;
  ttab[3]:='X';
  ttab[4]:='Jatek inditasa';
  tablazat(4);
  case jelzo of
   1:begin
     ttab[0]:='Ki iranyitsa az O-t?';
     ttab[1]:='Jatekos';
     ttab[2]:='Szamitogep';
     tablazat(2);
     if jelzo=2 then ogep:=true
     else ogep:=false;
   end;
   2:begin
     ttab[0]:='Ki iranyitsa a K-t?';
     ttab[1]:='Jatekos';
     ttab[2]:='Szamitogep';
     tablazat(2);
     if jelzo=2 then kgep:=true
     else kgep:=false;
   end;
   3:begin
     ttab[0]:='Ki iranyitsa az X-et?';
     ttab[1]:='Jatekos';
     ttab[2]:='Szamitogep';
     tablazat(2);
     if jelzo=2 then xgep:=true
     else xgep:=false;
   end;
  end;
 until jelzo=4;
 gotoxy(1,9);
 textcolor(11);
 writeln('o-nak el kell kapnia x-et. x-nek el kell kapnia ',#4,'-t. ',#4,'-nek pedig o-t.');
 writeln('Ir�nyit�s:');
 writeln('o: balra: A, jobbra: D, le: S, fel: W, fal lerak�sa: TAB.');
 writeln('x: balra: E`, jobbra: �, le: �, fel: �, fal lerak�sa: M');
 writeln(#4,': (num. billenty�zet)balra: 4, jobbra: 6, le: 5, fel: 8,');
 writeln('   fal lerak�sa: jobbra nyil (nem num. billenty�zet).');
 writeln('A folytat�shoz nyomjon meg egy gombot.');
 readkey;
 clrscr;
 gotoxy(1,1);    {A kezd� �letek ki�r�sa.}
 textcolor(10);
 write('o');
 gotoxy(76,1);
 textcolor(9);
 write('x');
 gotoxy(37,1);
 textcolor(14);
 write(#4);
 textcolor(15);
 gotoxy(1,3);    {Szeg�ly ki�r�sa}
 for i:=1 to 80 do
  write(#196);
 gotoh:=true;
 repeat
 for i:=1 to szam do begin {V�letlenszer� koordin�t�k sorsol�sa a t�rgyaknak.}
  targyak[i].x:=random(78)+2;
  targyak[i].y:=random(21)+4;
  if ((targyak[i].x=13) and (targyak[i].y=19)) or ((targyak[i].x=40) and (targyak[i].y=6)) or ((targyak[i].x=67) and (targyak[i].y=19)) then
   gotoh:=false;
  for j:=1 to (i-1) do begin{Ha egy t�rgy egy m�sik t�rgyon van rajta, �j koordin�t�t kap.}
   if (targyak[i].x=targyak[j].x) and (targyak[i].y=targyak[j].y) then
   gotoh:=false;
  end;
 end;
 until gotoh=true;
 for i:=1 to 5 do begin {o csapd�inak kirak�sa}
  scs[i].x:=i;
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(10);
  write(' ');
  textbackground(16);
 end;
 for i:=6 to 10 do begin {x csapd�inak kirak�sa}
  scs[i].x:=(70+i);
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(1);
  write(' ');
  textbackground(16);
 end;
 for i:=11 to 15 do begin {k csapd�inak kirak�sa}
  scs[i].x:=(26+i);
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(3);
  write(' ');
  textbackground(16);
 end;
 for i:=1 to 5 do begin {szivek kirak�sa}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(12);
  write(#3);
  textcolor(15);
 end;
 onyert:=false; {v�ltoz�k kezd� �rt�keinek megad�sa}
 xnyert:=false;
 knyert:=false;
 esc:=false;
 o:=1;
 x:=1;
 k:=1;
 ox:=13;
 oy:=19;
 xx:=67;
 xy:=19;
 kx:=40;
 ky:=6;
 ocs:=1;
 xcs:=6;
 kcs:=11;
 f:=1;
 g:=1;
 h:=1;
 for i:=1 to 5 do begin
  oc[i]:=1;
  os[i]:=1;
  ok[i]:=1;
 end;
 for i:=6 to 10 do begin
  cs[i]:=1;
  sc[i]:=1;
  kc[i]:=1;
 end;
 iro;
 irx;
 irk;
 for i:=6 to 10 do begin {a lila csapd�k ki�r�sa}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(5);
  write(#15);
  textcolor(15);
 end;
 delay(500);
 REPEAT {a repeat ciklus addig ism�tl�dik, am�g valaki nem nyer}
  fal1:=false;
  irx;
  iro;
  irk;
  for i:=6 to 10 do begin {a lila csapd�k ki�r�sa}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
  end;
  for i:=1 to 5 do begin {o spec. csapd�inak ki�r�sa}
   gotoxy(scs[i].x,scs[i].y);
   textbackground(2);
   write(' ');
   textbackground(0);
  end;
  for i:=6 to 10 do begin {x spec. csapd�inak ki�r�sa}
   gotoxy(scs[i].x,scs[i].y);
   textbackground(1);
   write(' ');
   textbackground(0);
  end;
  for i:=11 to 15 do begin {k spec. csapd�inak ki�r�sa}
   gotoxy(scs[i].x,scs[i].y);
   textbackground(6);
   write(' ');
   textbackground(0);
  end;  
  if (xgep=true) and (random(50)=0) then mi('x',ox,oy,kx,ky,0,xx,xy); {MI az x-re}
  if (ogep=true) and (random(50)=0) then mi('o',kx,ky,xx,xy,0,ox,oy); {MI az O-ra}
  if (kgep=true) and (random(50)=0) then mi('k',xx,xy,ox,oy,0,kx,ky);  
  if keypressed then begin
  if (ogep=true) and (kgep=false) and (xgep=false) then begin
   c:=readkey;   
   case c of
   ir[6]:begin
        if (fal(xx,xy,false,1,5,1,0)=false) and (fal(xx,xy,false,11,15,1,0)=false) then begin
         torolx;
         if (xx=80) and (xy=4) then xy:=24
         else begin
          if xy=4 then xy:=25
           else xy:=xy-1;
         end;
        end;
       end;
   ir[7]:begin
        if (fal(xx,xy,false,1,5,2,0)=false) and (fal(xx,xy,false,11,15,2,0)=false) then begin
         torolx;
         if (xx=1) and (xy=25) then xx:=79
         else begin
          if xx=1 then xx:=80
           else xx:=xx-1;
         end;
        end;
       end;
   ir[9]:begin
        if (fal(xx,xy,false,1,5,3,0)=false) and (fal(xx,xy,false,11,15,3,0)=false) then begin
         torolx;
         if (xx=80) and (xy=24) then xy:=4
         else begin
          if xy=25 then xy:=4
           else xy:=xy+1;
         end;
        end;
       end;
   ir[8]:begin
        if (fal(xx,xy,false,1,5,4,0)=false) and (fal(xx,xy,false,11,15,4,0)=false) then begin
         torolx;
         if (xx=79) and (xy=25) then xx:=1
         else begin
          if xx=80 then xx:=1
           else xx:=xx+1;
         end;
        end;
       end;
   ir[10]:xcsk;
   ir[11]:begin
        if fal(kx,ky,false,1,10,1,0)=false then begin
         torolk;
         if (kx=80) and (ky=4) then ky:=24
         else begin
          if ky=4 then ky:=25
           else ky:=ky-1;
         end;
        end;
       end;
   ir[12]:begin
        if fal(kx,ky,false,1,10,2,0)=false then begin
         torolk;
         if (kx=1) and (ky=25) then kx:=79
         else begin
          if kx=1 then kx:=80
           else kx:=kx-1;
         end;
        end;
       end;
   ir[14]:begin
        if fal(kx,ky,false,1,10,3,0)=false then begin
         torolk;
          if (kx=80) and (ky=24) then ky:=4
          else begin
           if ky=25 then ky:=4
            else ky:=ky+1;
          end;
         end;
       end;
   ir[13]:begin
        if fal(kx,ky,false,1,10,4,0)=false then begin
         torolk;
          if (kx=79) and (ky=25) then kx:=1
          else begin
           if kx=80 then kx:=1
            else kx:=kx+1;
          end;
         end;
       end;
   ir[15]:kcsk;
   #27:esc:=true;
  end;
 end;
  if (ogep=false) and (kgep=true) and (xgep=false) then begin
  c:=readkey;   
   case c of
   ir[6]:begin
        if (fal(xx,xy,false,1,5,1,0)=false) and (fal(xx,xy,false,11,15,1,0)=false) then begin
         torolx;
         if (xx=80) and (xy=4) then xy:=24
         else begin
          if xy=4 then xy:=25
           else xy:=xy-1;
         end;
        end;
       end;
   ir[7]:begin
        if (fal(xx,xy,false,1,5,2,0)=false) and (fal(xx,xy,false,11,15,2,0)=false) then begin
         torolx;
         if (xx=1) and (xy=25) then xx:=79
         else begin
          if xx=1 then xx:=80
           else xx:=xx-1;
         end;
        end;
       end;
   ir[9]:begin
        if (fal(xx,xy,false,1,5,3,0)=false) and (fal(xx,xy,false,11,15,3,0)=false) then begin
         torolx;
         if (xx=80) and (xy=24) then xy:=4
         else begin
          if xy=25 then xy:=4
           else xy:=xy+1;
         end;
        end;
       end;
   ir[8]:begin
        if (fal(xx,xy,false,1,5,4,0)=false) and (fal(xx,xy,false,11,15,4,0)=false) then begin
         torolx;
         if (xx=79) and (xy=25) then xx:=1
         else begin
          if xx=80 then xx:=1
           else xx:=xx+1;
         end;
        end;
       end;
   ir[10]:xcsk;
   ir[1]:begin
        if fal(ox,oy,false,6,15,1,0)=false then begin
         torolo;
         if (ox=80) and (oy=4) then oy:=24
         else begin
          if oy=4 then oy:=25
           else oy:=oy-1;
         end;
        end;
       end;
   ir[2]:begin
        if fal(ox,oy,false,6,15,2,0)=false then begin
         torolo;
         if (ox=1) and (oy=25) then ox:=79
         else begin
          if ox=1 then ox:=80
           else ox:=ox-1;
         end;
        end;
       end;
   ir[4]:begin
        if fal(ox,oy,false,6,15,3,0)=false then begin
         torolo;
         if (ox=80) and (oy=24) then oy:=4
         else begin
          if oy=25 then oy:=4
           else oy:=oy+1;
         end;
        end;
       end;
   ir[3]:begin
        if fal(ox,oy,false,6,15,4,0)=false then begin
         torolo;
         if (ox=79) and (oy=25) then ox:=1
         else begin
          if ox=80 then ox:=1
           else ox:=ox+1;
         end;
        end;
       end;
    ir[5]:ocsk;
   #27:esc:=true;
  end;
  end;
  
  if (ogep=false) and (kgep=false) and (xgep=true) then begin
  c:=readkey;   
   case c of
   ir[1]:begin
        if fal(ox,oy,false,6,15,1,0)=false then begin
         torolo;
         if (ox=80) and (oy=4) then oy:=24
         else begin
          if oy=4 then oy:=25
           else oy:=oy-1;
         end;
        end;
       end;
   ir[2]:begin
        if fal(ox,oy,false,6,15,2,0)=false then begin
         torolo;
         if (ox=1) and (oy=25) then ox:=79
         else begin
          if ox=1 then ox:=80
           else ox:=ox-1;
         end;
        end;
       end;
   ir[4]:begin
        if fal(ox,oy,false,6,15,3,0)=false then begin
         torolo;
         if (ox=80) and (oy=24) then oy:=4
         else begin
          if oy=25 then oy:=4
           else oy:=oy+1;
         end;
        end;
       end;
   ir[3]:begin
        if fal(ox,oy,false,6,15,4,0)=false then begin
         torolo;
         if (ox=79) and (oy=25) then ox:=1
         else begin
          if ox=80 then ox:=1
           else ox:=ox+1;
         end;
        end;
       end;
    ir[5]:ocsk;
   ir[11]:begin
        if fal(kx,ky,false,1,10,1,0)=false then begin
         torolk;
         if (kx=80) and (ky=4) then ky:=24
         else begin
          if ky=4 then ky:=25
           else ky:=ky-1;
         end;
        end;
       end;
   ir[12]:begin
        if fal(kx,ky,false,1,10,2,0)=false then begin
         torolk;
         if (kx=1) and (ky=25) then kx:=79
         else begin
          if kx=1 then kx:=80
           else kx:=kx-1;
         end;
        end;
       end;
   ir[14]:begin
        if fal(kx,ky,false,1,10,3,0)=false then begin
         torolk;
          if (kx=80) and (ky=24) then ky:=4
          else begin
           if ky=25 then ky:=4
            else ky:=ky+1;
          end;
         end;
       end;
   ir[13]:begin
        if fal(kx,ky,false,1,10,4,0)=false then begin
         torolk;
          if (kx=79) and (ky=25) then kx:=1
          else begin
           if kx=80 then kx:=1
            else kx:=kx+1;
          end;
         end;
       end;
   ir[15]:kcsk;
   #27:esc:=true;
  end;
  end;
  
  if (ogep=true) and (kgep=true) and (xgep=false) then begin
  c:=readkey;   
   case c of
   ir[6]:begin
        if (fal(xx,xy,false,1,5,1,0)=false) and (fal(xx,xy,false,11,15,1,0)=false) then begin
         torolx;
         if (xx=80) and (xy=4) then xy:=24
         else begin
          if xy=4 then xy:=25
           else xy:=xy-1;
         end;
        end;
       end;
   ir[7]:begin
        if (fal(xx,xy,false,1,5,2,0)=false) and (fal(xx,xy,false,11,15,2,0)=false) then begin
         torolx;
         if (xx=1) and (xy=25) then xx:=79
         else begin
          if xx=1 then xx:=80
           else xx:=xx-1;
         end;
        end;
       end;
   ir[9]:begin
        if (fal(xx,xy,false,1,5,3,0)=false) and (fal(xx,xy,false,11,15,3,0)=false) then begin
         torolx;
         if (xx=80) and (xy=24) then xy:=4
         else begin
          if xy=25 then xy:=4
           else xy:=xy+1;
         end;
        end;
       end;
   ir[8]:begin
        if (fal(xx,xy,false,1,5,4,0)=false) and (fal(xx,xy,false,11,15,4,0)=false) then begin
         torolx;
         if (xx=79) and (xy=25) then xx:=1
         else begin
          if xx=80 then xx:=1
           else xx:=xx+1;
         end;
        end;
       end;
   ir[10]:xcsk;
   #27:esc:=true;
  end;
  end;
  
  if (ogep=true) and (kgep=false) and (xgep=true) then begin
  c:=readkey;   
   case c of
   ir[11]:begin
        if fal(kx,ky,false,1,10,1,0)=false then begin
         torolk;
         if (kx=80) and (ky=4) then ky:=24
         else begin
          if ky=4 then ky:=25
           else ky:=ky-1;
         end;
        end;
       end;
   ir[12]:begin
        if fal(kx,ky,false,1,10,2,0)=false then begin
         torolk;
         if (kx=1) and (ky=25) then kx:=79
         else begin
          if kx=1 then kx:=80
           else kx:=kx-1;
         end;
        end;
       end;
   ir[14]:begin
        if fal(kx,ky,false,1,10,3,0)=false then begin
         torolk;
          if (kx=80) and (ky=24) then ky:=4
          else begin
           if ky=25 then ky:=4
            else ky:=ky+1;
          end;
         end;
       end;
   ir[13]:begin
        if fal(kx,ky,false,1,10,4,0)=false then begin
         torolk;
          if (kx=79) and (ky=25) then kx:=1
          else begin
           if kx=80 then kx:=1
            else kx:=kx+1;
          end;
         end;
       end;
   ir[15]:kcsk;
   #27:esc:=true;
  end;
  end;
  
  if (ogep=false) and (kgep=true) and (xgep=true) then begin
  c:=readkey;   
   case c of
   ir[1]:begin
        if fal(ox,oy,false,6,15,1,0)=false then begin
         torolo;
         if (ox=80) and (oy=4) then oy:=24
         else begin
          if oy=4 then oy:=25
           else oy:=oy-1;
         end;
        end;
       end;
   ir[2]:begin
        if fal(ox,oy,false,6,15,2,0)=false then begin
         torolo;
         if (ox=1) and (oy=25) then ox:=79
         else begin
          if ox=1 then ox:=80
           else ox:=ox-1;
         end;
        end;
       end;
   ir[4]:begin
        if fal(ox,oy,false,6,15,3,0)=false then begin
         torolo;
         if (ox=80) and (oy=24) then oy:=4
         else begin
          if oy=25 then oy:=4
           else oy:=oy+1;
         end;
        end;
       end;
   ir[3]:begin
        if fal(ox,oy,false,6,15,4,0)=false then begin
         torolo;
         if (ox=79) and (oy=25) then ox:=1
         else begin
          if ox=80 then ox:=1
           else ox:=ox+1;
         end;
        end;
       end;
    ir[5]:ocsk;
   #27:esc:=true;
  end;
  end;
  
  if (ogep=false) and (kgep=false) and (xgep=false) then begin
  c:=readkey;   
   case c of
   ir[6]:begin
        if (fal(xx,xy,false,1,5,1,0)=false) and (fal(xx,xy,false,11,15,1,0)=false) then begin
         torolx;
         if (xx=80) and (xy=4) then xy:=24
         else begin
          if xy=4 then xy:=25
           else xy:=xy-1;
         end;
        end;
       end;
   ir[7]:begin
        if (fal(xx,xy,false,1,5,2,0)=false) and (fal(xx,xy,false,11,15,2,0)=false) then begin
         torolx;
         if (xx=1) and (xy=25) then xx:=79
         else begin
          if xx=1 then xx:=80
           else xx:=xx-1;
         end;
        end;
       end;
   ir[9]:begin
        if (fal(xx,xy,false,1,5,3,0)=false) and (fal(xx,xy,false,11,15,3,0)=false) then begin
         torolx;
         if (xx=80) and (xy=24) then xy:=4
         else begin
          if xy=25 then xy:=4
           else xy:=xy+1;
         end;
        end;
       end;
   ir[8]:begin
        if (fal(xx,xy,false,1,5,4,0)=false) and (fal(xx,xy,false,11,15,4,0)=false) then begin
         torolx;
         if (xx=79) and (xy=25) then xx:=1
         else begin
          if xx=80 then xx:=1
           else xx:=xx+1;
         end;
        end;
       end;
   ir[10]:xcsk;
   ir[11]:begin
        if fal(kx,ky,false,1,10,1,0)=false then begin
         torolk;
         if (kx=80) and (ky=4) then ky:=24
         else begin
          if ky=4 then ky:=25
           else ky:=ky-1;
         end;
        end;
       end;
   ir[12]:begin
        if fal(kx,ky,false,1,10,2,0)=false then begin
         torolk;
         if (kx=1) and (ky=25) then kx:=79
         else begin
          if kx=1 then kx:=80
           else kx:=kx-1;
         end;
        end;
       end;
   ir[14]:begin
        if fal(kx,ky,false,1,10,3,0)=false then begin
         torolk;
          if (kx=80) and (ky=24) then ky:=4
          else begin
           if ky=25 then ky:=4
            else ky:=ky+1;
          end;
         end;
       end;
   ir[13]:begin
        if fal(kx,ky,false,1,10,4,0)=false then begin
         torolk;
          if (kx=79) and (ky=25) then kx:=1
          else begin
           if kx=80 then kx:=1
            else kx:=kx+1;
          end;
         end;
       end;
   ir[15]:kcsk;
   ir[1]:begin
        if fal(ox,oy,false,6,15,1,0)=false then begin
         torolo;
         if (ox=80) and (oy=4) then oy:=24
         else begin
          if oy=4 then oy:=25
           else oy:=oy-1;
         end;
        end;
       end;
   ir[2]:begin
        if fal(ox,oy,false,6,15,2,0)=false then begin
         torolo;
         if (ox=1) and (oy=25) then ox:=79
         else begin
          if ox=1 then ox:=80
           else ox:=ox-1;
         end;
        end;
       end;
   ir[4]:begin
        if fal(ox,oy,false,6,15,3,0)=false then begin
         torolo;
         if (ox=80) and (oy=24) then oy:=4
         else begin
          if oy=25 then oy:=4
           else oy:=oy+1;
         end;
        end;
       end;
   ir[3]:begin
        if fal(ox,oy,false,6,15,4,0)=false then begin
         torolo;
         if (ox=79) and (oy=25) then ox:=1
         else begin
          if ox=80 then ox:=1
           else ox:=ox+1;
         end;
        end;
       end;
    ir[5]:ocsk;
   #27:esc:=true;
  end;
  end;
 end; 

  
  
  

 for i:=1 to 5 do begin{Ha x sz�vre l�p}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   xkap;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin{Ha o sz�vre l�p}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   okap;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin{Ha k sz�vre l�p}
  if (kx=targyak[i].x) and (ky=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   kkap;
   sziv:=sziv+1;
   end;
  end;
 for i:=6 to 10 do begin{Ha x lila csapd�ra l�p}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   if cs[i]=1 then begin
    xveszt;
    cs[i]:=cs[i]+1;
   end;
  end else
  cs[i]:=1
 end;
 for i:=6 to 10 do begin{Ha o lila csapd�ra l�p}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   if sc[i]=1 then begin
    oveszt;
    sc[i]:=sc[i]+1;
   end;
  end else
  sc[i]:=1
 end;
 for i:=6 to 10 do begin{Ha k lila csapd�ra l�p}
  if (kx=targyak[i].x) and (ky=targyak[i].y) then begin
   if kc[i]=1 then begin
    kveszt;
    kc[i]:=kc[i]+1;
   end;
  end else
  kc[i]:=1
 end;
 if (xx=ox) and (xy=oy) then begin{Ha o x-re l�p}
  if f=1 then begin
   xveszt;
   f:=f+1;
  end;
 end else
 f:=1;
 if (kx=xx) and (ky=xy) then begin{Ha x k-ra l�p}
  if g=1 then begin
   kveszt;
   g:=g+1;
  end;
 end else
 g:=1;
 if (ox=kx) and (oy=ky) then begin{Ha k o-ra l�p}
  if f=1 then begin
   oveszt;
   h:=h+1;
  end;
 end else
 h:=1;
 if (x<=0) then onyert:=true; {Ha valakinek 0 �lete van, akkor valaki nyer.}
 if (o<=0) then knyert:=true;
 if (k<=0) then xnyert:=true;
 until (onyert=true) or (xnyert=true) or (knyert=true) or (esc=true);{a repeat ciklus v�ge, ha valaki nyert.}
 clrscr; {Gratul�ci� a gy�ztesnek, gombnyom�sra kil�p, de legal�bb 5 mp-ig mutatja.}
 gotoxy(16,12);
 textcolor(11);
 if onyert=true then begin
  write('Nyertel, kedves ');
  textcolor(10);
  write('O');
  textcolor(11);
  write('! Nagyon �gyes vagy! Gratulalok!');
 end;
 if xnyert=true then begin
  write('Nyertel, kedves ');
  textcolor(9);
  write('X');
  textcolor(11);
  write('! Nagyon ugyes vagy! Gratulalok!');
 end;
 if knyert=true then begin
  write('Nyertel, kedves ');
  textcolor(14);
  write(#4);
  textcolor(11);
  write('! Nagyon �gyes vagy! Gratulalok!');
 end;
 if esc=false then begin
  repeat
   c:=readkey;
  until c=#13;
 end;
 {---ID�IG TART A 3 SZEM�LYES---}
 end;
 3: begin
  clrscr;
  textcolor(11);
  writeln('Alapbeallitas:');
  writeln('O: Fel:W Balra:A Jobbra:D Le:S Bomba/Fal:Tab');
  writeln('X: Fel:8 Balra:4 Jobbra:6 Le:5 Bomba/Fal:0, Ins');
  writeln('K: Fel:� Balra:� Jobbra:� Le:� Bomba/Fal:M');
  writeln('A nyilakat nem lehet iranyitaskent megadni!');
  readkey;
  clrscr;
  ttab[0]:='Melyik jatekos iranyitasat szeretned atallitani?';
  ttab[1]:='O';
  ttab[2]:='X';
  ttab[3]:='K';
  tablazat(3);
  clrscr;
  write('Fel                ');
  ir[(jelzo-1)*5+1]:=readkey;
  textcolor(3);
  writeln(ir[(jelzo-1)*5+1]);
  textcolor(11);
  write('Balra              ');
  ir[(jelzo-1)*5+2]:=readkey;
  textcolor(3);
  writeln(ir[(jelzo-1)*5+2]);
  textcolor(11);
  write('Jobbra             ');
  ir[(jelzo-1)*5+3]:=readkey;
  textcolor(3);
  writeln(ir[(jelzo-1)*5+3]);
  textcolor(11);
  write('Le                 ');
  ir[(jelzo-1)*5+4]:=readkey;
  textcolor(3);
  writeln(ir[(jelzo-1)*5+4]);
  textcolor(11);
  write('Bomba/Fal lerakasa ');
  ir[(jelzo-1)*5+5]:=readkey;
  textcolor(3);
  writeln(ir[(jelzo-1)*5+5]);
  textcolor(11);
  writeln('Nyomj meg egy gombot');
  readkey;
 end;
 4: halt;
 end;{A f�men� case-�nek end-je}
 UNTIL xx=100; {Csak az a l�nyeg, hogy az elej�re menjen, a felt�tel sosem teljes�l}
end.
