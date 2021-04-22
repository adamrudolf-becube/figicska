program figipro;
uses crt;
                                    {1-5: élet
                                     6-10: csapda
                                     11:jobb alsó sarok}
const szam=11;                      {Tárgyak (életek és lila csapdák) száma.}
type koord=record                   {Tárgyak típusa, x és y koordináta.}
 x:byte;
 y:byte;
 end;
var
 ox,oy,xx,xy,kx,ky,i:byte;          {Játékosok koordinátái és ciklusváltozó.}
 x,o,k:smallint;                    {Játékosok életei.}
 targyak: array[1..szam] of koord;  {A tárgyak (életek és lila csapdák) koordinátáinak tömbje.}
 j:byte;                            {2. ciklusváltozó. Oda kell, ahol 2 for van egymáson belül.}
 scs:array[1..15] of koord;         {Spec. csapdák koordinátái. 1-5:o 6-10:x 11-15:k.}
 cs,sc,kc:array[6..10] of integer;  {Azt vizsgálja, hogy a játékos rálépett-e az adott lila csapdára, vagy rajta állt.}
 f,g,h:integer;                     {Azt vizsgálja, hogy a játékos a másikra lépett-e, vagy rajta áll.}
 c:char;                            {Az irányítás ebben tárolódik.}
 onyert,xnyert,knyert:boolean;      {Igazzá válik, ha az adott játékos nyert.}
 esc:boolean;                       {Igazzá válik, ha valaki esc-et nyom}
 ocs,xcs,kcs:byte;                  {Azt vizsgálja, hogy hanyadik csapdát rakja le az adott játékos.}
 os:array[1..5] of integer;
 oc:array[1..5] of integer;         {Azt vizsgálja, hogy az adott spec. csapdára lépett-e a játékos, vagy rajta állt-e.}
 ok:array[1..5] of integer;
 fal1:boolean;
 ttab: array[0..99] of string;      {A menühöz kell (az elemeit tárolja)}
 jelzo:byte;                        {Ez is (azt jelzi, hogy melyik elem van kiválasztva)}
 gotoh:boolean;                     {Akkor van szerepe, mikor a program a kezdésnél vizsgálja, hogy a tárgyak nincsenek-e egymáson. a goto-t váltja fel}
 ir:array[1..15] of char;           {Az iranyítás gombjait tárolja}
 {1:fel, 2:balra, 3:jobbra, 4: le, 5:bomba, sorrend:o,x,k}
 r:byte;                            {random számításhoz}
 sziv:byte;                         {azt számolja, hogy hány szív lett felvéve}
 ogep,xgep,kgep:boolean;            {akkor igaz, ha az adott karaktert a gép irányítja}
procedure tablazat(tszam:integer);  {A táblázat (menü) kirajzolása}
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
{x,y:a lépõ fél koordinátái. tomb:igaz, ha a targyak tömböt nézi és hamis,
ha az scs-t. alfa, omega: mettõl meddig vizsgálja a tömb elemeit
a:irány. 1:fel.2:balra,3:le,4:jobbra, s:verzió-. 1, ha kétszemélyes}
 begin
  fal:=false;
  if tomb=true then begin
   case a of
   1:begin
     for i:=alfa to omega do begin
      if (targyak[i].x=x) and (targyak[i].y=(y-1)) then fal:=true;                   
      if (s=1) and (y=3) and (targyak[i].x=x) and (targyak[i].y=25) then fal:=true;  //Ha a karakter a pálya tetején van, a tárgy meg a pálya alján
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
procedure torolo;{o törlése}
 begin
 gotoxy(ox,oy);
 write(' ');
 end;
procedure torolx;{x törlése}
 begin
 gotoxy(xx,xy);
 write(' ');
 end;
procedure torolk;{k törlése}
 begin
 gotoxy(kx,ky);
 write(' ');
 end;
procedure iro;{o kiírása}
 begin
 gotoxy(ox,oy);
 textcolor(10);
 write('o');
 textcolor(11);
 end;
procedure irx;{x kiírása}
 begin
 gotoxy(xx,xy);
 textcolor(9);
 write('x');
 textcolor(11);
 end;
procedure irk;{k kiírása}
 begin
 gotoxy(kx,ky);
 textcolor(14);
 write(#4);
 textcolor(11);
 end;
procedure okap;{o életet kap}
 begin
 o:=o+1;
 gotoxy(o,1);
 textcolor(10);
 write('o');
 textcolor(11);
 end;
procedure oveszt;{o életet veszt}
 begin
 gotoxy(o,1);
 write(' ');
 o:=o-1;
 end;
procedure xkap;{x életet kap}
 begin
 x:=x+1;
 gotoxy((75+x),1);
 textcolor(9);
 write('x');
 textcolor(11);
 end;
procedure xveszt;{x életet veszt}
 begin
 gotoxy((75+x),1);
 write(' ');
 x:=x-1;
 end;
procedure kkap;{k életet kap}
 begin
 k:=k+1;
 gotoxy((36+k),1);
 textcolor(14);
 write(#4);
 textcolor(11);
 end;
procedure kveszt;{k életet veszt}
 begin
 gotoxy((36+k),1);
 write(' ');
 k:=k-1;
 end;
procedure ocsk;{o falat helyez el (három személyesben)}
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
procedure xcsk;{x falat helyez el (három személyesben)}
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
procedure kcsk;{k falat helyez el (három személyesben)}
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
procedure fel(b:char;s:smallint); {Fellépés az MI-hez. b a karakter, aki lép, s pedig 1, ha 2 személyes a verzió (mert más a pálya mérete}
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
procedure jobbra(b:char;s:smallint); {MI-hez jobbra lépés. B: melyik karaktert léptesse}
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
procedure le(b:char;s:smallint); {Lelépés MI-hez. Paraméterek: lásd fellépés}
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
procedure balra(b:char;s:smallint); {MI-hez balra lépés. b:melyik karaktert mozgatja}
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
{az ax,ay és bx,by koordinátájó pontok távolságát adja vissza}
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
{Mesterséges Intelligencia Közeledésre.
A b paraméter az a játékos betûje, akit az MI mozgat. S=1, ha 2 személyes a verzió
ux,uy: az üldözõ koordinátáinak változói, mx,my: a menekülõ k. változói}
 var f,v:byte; {f:1=fölötte,2=egy sor,3=alatta;v:1=balra,2=egy oszlop,3=jobbra}
     r:byte;
 begin
  {Vízszintes vizsgálat:v esetei: 3:jobbra 2:semerre 1:balra érdemes menni}
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
  {Függõleges vizsgálat:f esetei:1:fel 2:semerre 3: lefele érdemesebb menni}
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
{Mesterséges Intelligencia Távolodásra.
A b paraméter az a játékos betûje, akit az MI mozgat. S=1, ha 2 személyes a verzió
ux,uy: az intelligens koordinátáinak változói, mx,my: az üldözõ k. változói}
 var f,v:byte; {f:1=fölötte,2=egy sor,3=alatta;v:1=balra,2=egy oszlop,3=jobbra}
     r:byte;
 begin
  {Vízszintes vizsgálat:v esetei: 3:jobbra 2:semerre 1:balra érdemes menni}
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
  {Függõleges vizsgálat:f esetei:1:fel 2:semerre 3: lefele érdemesebb menni}
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
{b:a karakter betûje. ux,uy:az õt üldözõ koordinátái. mx,my: az elõle
menekülõ koordinátái,s a verziószám, 1 ha 2 személyes, x,y:az irányított
fél koordinátái}
 var min,sorsz:byte;
 begin
  if (b='x') and (s=1) then begin //x irányítása a kétszemélyes verzióban   
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
  else begin  //Összes többi eset
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
{---Innentõl a 2 személyes verzió eljárásai, hogyha más, mint a 3 személyesben---}
procedure okap2; {o életet kap}
 begin
 o:=o+1;
 gotoxy(o,1);
 textcolor(10);
 write('o');
 textcolor(15);
 end;
procedure oveszt2; {o életet veszít}
 begin
 gotoxy(o,1);
 write(' ');
 o:=o-1;
 end;
procedure xkap2; {x életet kap}
 begin
 x:=x+1;
 gotoxy((81-x),1);
 textcolor(9);
 write('x');
 textcolor(15);
 end;
procedure xveszt2; {x életet veszít}
 begin
 gotoxy((81-x),1);
 write(' ');
 x:=x-1;
 end;
procedure ocsk2; {o speciális csapdát helyez el}
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
procedure xcsk2; {x speciális csapdát helyez el}
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
 REPEAT {A játék végeztével lép ide vissza}
 clrscr;
 ttab[0]:='FigiPro';
 ttab[1]:='Ketszemelyes FigiPro inditasa';
 ttab[2]:='Haromszemelyes FigiPro inditasa';
 ttab[3]:='Beallitasok';
 ttab[4]:='Kilepes';
 tablazat(4);
 case jelzo of
 1:begin
 {---ITT KEZDÕDIK A KÉTSZEMÉLYES VERZIÓ---}
 ttab[1]:='Ket jatekos';
 ttab[2]:='Egy jatekos: O';
 ttab[3]:='Egy jatekos: X';
 ttab[4]:='Jatekos nelkul (ket gep)';
 tablazat(4);
 gotoxy(1,1);     {életek kiírása a kezdõ helyre}
 textcolor(10);
 write('o');
 gotoxy(80,1);
 textcolor(9);
 write('x');
 textcolor(15);
 gotoxy(1,2);
 for i:=1 to 80 do  {szegély kirajzolása}
  write(#196);
 gotoh:=true;       {véletlenszerû koordinátákat sorsol a tárgyaknak, ha pedig két tárgy ugyanoda kerül, vagy egy játékos helyére kerül, akkor újat sorsol az összesnek}
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
 for i:=1 to 5 do begin {o speciális csapdáinak kirakása a kezdõ helyre}
  scs[i].x:=(i+34);
  scs[i].y:=1;
  gotoxy(scs[i].x,scs[i].y);
  textcolor(2);
  write(#15);
  textcolor(15);
 end;
 for i:=6 to 10 do begin {x speciális csapdáinak kirakása a kezdõ helyre}
  scs[i].x:=(i+36);
  scs[i].y:=1;
  gotoxy(scs[i].x,scs[i].y);
  textcolor(1);
  write(#15);
  textcolor(15);
 end;
 for i:=1 to 5 do begin {életek kirajzolása}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(12);
  write(#3);
  textcolor(15);
 end;
 onyert:=false;    {változók kezdõértékeinek beállításai}
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
 for i:=6 to 10 do begin {minden ciklusban újra kirajzolja a csapdákat}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
 end;
 delay(500); {vár egy fél másodpercet, hogy a játékosok fel tudjanak készülni}
 REPEAT      {ez a nagy ciklus ismétlõdik addig, amíg valaki nem nyer}
  for i:=6 to 10 do begin {minden ciklusban újra kirajzolja a csapdákat}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
  end;
  iro; {iírja x-et és o-t}
  irx;
  for i:=1 to 5 do begin      {o speciális csapdáit írja ki}
   gotoxy(scs[i].x,scs[i].y);
   textcolor(2);
   write(#15);
   textcolor(15);
  end;
  for i:=6 to 10 do begin     {x speciális csapdáit írja ki}
   gotoxy(scs[i].x,scs[i].y);
   textcolor(1);
   write(#15);
   textcolor(15);
  end;              {irányítás}
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
 for i:=1 to 5 do begin {ha x életre lép, életet kap}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   xkap2;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin {ha o életre lép, o életet kap}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   okap2;
   sziv:=sziv+1;
   end;
  end;
 for i:=6 to 10 do begin {ha x csapdára lép, életet veszít}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   if cs[i]=1 then begin
    xveszt2;
    cs[i]:=cs[i]+1;
   end;
  end else
  cs[i]:=1
 end;
 for i:=6 to 10 do begin {ha o csapdára lép, életet veszít}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   if sc[i]=1 then begin
    oveszt2;
    sc[i]:=sc[i]+1;
   end;
  end else
  sc[i]:=1
 end;
 for i:=1 to 5 do begin {ha x o speciális csapdájára lép, életet veszít}
  if (xx=scs[i].x) and (xy=scs[i].y) then begin
   if os[i]=1 then begin
    xveszt2;
    os[i]:=os[i]+1;
   end;
  end else
  os[i]:=1
 end;
 for i:=6 to 10 do begin {ha o x speciális csapdájára lép, életet veszít}
  if (ox=scs[i].x) and (oy=scs[i].y) then begin
   if oc[i]=1 then begin
    oveszt2;
    oc[i]:=oc[i]+1;
   end;
  end else
  oc[i]:=1
 end;
 if (xx=ox) and (xy=oy) then begin {ha x és o egy helyen álnak, x életet veszít}
  if f=1 then begin
   xveszt2;
   f:=f+1;
   end;
  end
  else
   f:=1;
 if (x<=0) then onyert:=true; {ha x-nek elfogy az élete, veszít}
 if (o<=0) then xnyert:=true; {ha o-nak elfogy az élete, veszít}
 until (onyert=true) or (xnyert=true) or (esc=true); {a nagy REPEAT ciklus vége}
 clrscr;
 gotoxy(16,12);       {a gyõztes kihirdetése}
 textcolor(11);
 if onyert=true then begin
  write('Nyertel, kedves ');
  textcolor(10);
  write('O');
  textcolor(11);
  write('! Nagyon ügyes vagy! Gratulalok!');
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
 {---ITT VAN VÉGE A KÉTSZEMÉLYES VERZIÓNAK---}
 end;
 2: begin
 {---INNENTÕL 3 SZEMÉLYES---}
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
 writeln('Irányitás:');
 writeln('o: balra: A, jobbra: D, le: S, fel: W, fal lerakása: TAB.');
 writeln('x: balra: E`, jobbra: Ü, le: Á, fel: Ö, fal lerakása: M');
 writeln(#4,': (num. billentyüzet)balra: 4, jobbra: 6, le: 5, fel: 8,');
 writeln('   fal lerakása: jobbra nyil (nem num. billentyüzet).');
 writeln('A folytatáshoz nyomjon meg egy gombot.');
 readkey;
 clrscr;
 gotoxy(1,1);    {A kezdõ életek kiírása.}
 textcolor(10);
 write('o');
 gotoxy(76,1);
 textcolor(9);
 write('x');
 gotoxy(37,1);
 textcolor(14);
 write(#4);
 textcolor(15);
 gotoxy(1,3);    {Szegély kiírása}
 for i:=1 to 80 do
  write(#196);
 gotoh:=true;
 repeat
 for i:=1 to szam do begin {Véletlenszerû koordináták sorsolása a tárgyaknak.}
  targyak[i].x:=random(78)+2;
  targyak[i].y:=random(21)+4;
  if ((targyak[i].x=13) and (targyak[i].y=19)) or ((targyak[i].x=40) and (targyak[i].y=6)) or ((targyak[i].x=67) and (targyak[i].y=19)) then
   gotoh:=false;
  for j:=1 to (i-1) do begin{Ha egy tárgy egy másik tárgyon van rajta, új koordinátát kap.}
   if (targyak[i].x=targyak[j].x) and (targyak[i].y=targyak[j].y) then
   gotoh:=false;
  end;
 end;
 until gotoh=true;
 for i:=1 to 5 do begin {o csapdáinak kirakása}
  scs[i].x:=i;
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(10);
  write(' ');
  textbackground(16);
 end;
 for i:=6 to 10 do begin {x csapdáinak kirakása}
  scs[i].x:=(70+i);
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(1);
  write(' ');
  textbackground(16);
 end;
 for i:=11 to 15 do begin {k csapdáinak kirakása}
  scs[i].x:=(26+i);
  scs[i].y:=2;
  gotoxy(scs[i].x,scs[i].y);
  textbackground(3);
  write(' ');
  textbackground(16);
 end;
 for i:=1 to 5 do begin {szivek kirakása}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(12);
  write(#3);
  textcolor(15);
 end;
 onyert:=false; {változók kezdõ értékeinek megadása}
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
 for i:=6 to 10 do begin {a lila csapdák kiírása}
  gotoxy(targyak[i].x,targyak[i].y);
  textcolor(5);
  write(#15);
  textcolor(15);
 end;
 delay(500);
 REPEAT {a repeat ciklus addig ismétlõdik, amíg valaki nem nyer}
  fal1:=false;
  irx;
  iro;
  irk;
  for i:=6 to 10 do begin {a lila csapdák kiírása}
   gotoxy(targyak[i].x,targyak[i].y);
   textcolor(5);
   write(#15);
   textcolor(15);
  end;
  for i:=1 to 5 do begin {o spec. csapdáinak kiírása}
   gotoxy(scs[i].x,scs[i].y);
   textbackground(2);
   write(' ');
   textbackground(0);
  end;
  for i:=6 to 10 do begin {x spec. csapdáinak kiírása}
   gotoxy(scs[i].x,scs[i].y);
   textbackground(1);
   write(' ');
   textbackground(0);
  end;
  for i:=11 to 15 do begin {k spec. csapdáinak kiírása}
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

  
  
  

 for i:=1 to 5 do begin{Ha x szívre lép}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   xkap;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin{Ha o szívre lép}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   okap;
   sziv:=sziv+1;
   end;
  end;
 for i:=1 to 5 do begin{Ha k szívre lép}
  if (kx=targyak[i].x) and (ky=targyak[i].y) then begin
   targyak[i].x:=160;
   targyak[i].y:=50;
   kkap;
   sziv:=sziv+1;
   end;
  end;
 for i:=6 to 10 do begin{Ha x lila csapdára lép}
  if (xx=targyak[i].x) and (xy=targyak[i].y) then begin
   if cs[i]=1 then begin
    xveszt;
    cs[i]:=cs[i]+1;
   end;
  end else
  cs[i]:=1
 end;
 for i:=6 to 10 do begin{Ha o lila csapdára lép}
  if (ox=targyak[i].x) and (oy=targyak[i].y) then begin
   if sc[i]=1 then begin
    oveszt;
    sc[i]:=sc[i]+1;
   end;
  end else
  sc[i]:=1
 end;
 for i:=6 to 10 do begin{Ha k lila csapdára lép}
  if (kx=targyak[i].x) and (ky=targyak[i].y) then begin
   if kc[i]=1 then begin
    kveszt;
    kc[i]:=kc[i]+1;
   end;
  end else
  kc[i]:=1
 end;
 if (xx=ox) and (xy=oy) then begin{Ha o x-re lép}
  if f=1 then begin
   xveszt;
   f:=f+1;
  end;
 end else
 f:=1;
 if (kx=xx) and (ky=xy) then begin{Ha x k-ra lép}
  if g=1 then begin
   kveszt;
   g:=g+1;
  end;
 end else
 g:=1;
 if (ox=kx) and (oy=ky) then begin{Ha k o-ra lép}
  if f=1 then begin
   oveszt;
   h:=h+1;
  end;
 end else
 h:=1;
 if (x<=0) then onyert:=true; {Ha valakinek 0 élete van, akkor valaki nyer.}
 if (o<=0) then knyert:=true;
 if (k<=0) then xnyert:=true;
 until (onyert=true) or (xnyert=true) or (knyert=true) or (esc=true);{a repeat ciklus vége, ha valaki nyert.}
 clrscr; {Gratuláció a gyõztesnek, gombnyomásra kilép, de legalább 5 mp-ig mutatja.}
 gotoxy(16,12);
 textcolor(11);
 if onyert=true then begin
  write('Nyertel, kedves ');
  textcolor(10);
  write('O');
  textcolor(11);
  write('! Nagyon ügyes vagy! Gratulalok!');
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
  write('! Nagyon ügyes vagy! Gratulalok!');
 end;
 if esc=false then begin
  repeat
   c:=readkey;
  until c=#13;
 end;
 {---IDÁIG TART A 3 SZEMÉLYES---}
 end;
 3: begin
  clrscr;
  textcolor(11);
  writeln('Alapbeallitas:');
  writeln('O: Fel:W Balra:A Jobbra:D Le:S Bomba/Fal:Tab');
  writeln('X: Fel:8 Balra:4 Jobbra:6 Le:5 Bomba/Fal:0, Ins');
  writeln('K: Fel:Õ Balra:É Jobbra:Û Le:Á Bomba/Fal:M');
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
 end;{A fõmenü case-ének end-je}
 UNTIL xx=100; {Csak az a lényeg, hogy az elejére menjen, a feltétel sosem teljesül}
end.
