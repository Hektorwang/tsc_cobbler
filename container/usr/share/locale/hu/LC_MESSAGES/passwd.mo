��    9      �  O   �      �     �  @     1   E  )   w  '   �  3   �  (   �  &   &     M  4   j     �  !   �  8   �  !     $   5  "   Z     }  4   �  "   �  '   �          :     R     b     h     �     �     �  4   �     	      	     1	     J	     c	     	     �	  $   �	     �	     �	     
      
  "   6
  *   Y
     �
  X   �
  5   �
     -  &   =  3   d  %   �  %   �  U   �  L   :  &   �  7   �  5   �  �       �  U     E   [  0   �  7   �  K   
  /   V  4   �  ,   �  7   �        0   ?  <   p  "   �  2   �  /        3  F   R  4   �  3   �  1        4     Q     `  !   e  5   �  *   �     �  4     %   9     _  &   q  &   �  )   �  )   �  +     8   ?  /   x  	   �     �  *   �  5   �  1   .     `  w   {  Q   �     E  -   a  F   �  7   �  7     `   F  k   �  E     S   Y  F   �             '   +   8          &   5               *       (                 .   3      $   1         #                        %         /                        2             7       ,   -   )                    	       "       9           
          !         4                 0   6    %s: Can not identify you!
 %s: Cannot mix one of -l, -u, -d, -S and one of -i, -n, -w, -x.
 %s: Only one of -l, -u, -d, -S may be specified.
 %s: Only one user name may be specified.
 %s: Only root can specify a user name.
 %s: SELinux denying access due to security policy.
 %s: The user name supplied is too long.
 %s: This option requires a user name.
 %s: Unknown user name '%s'.
 %s: all authentication tokens updated successfully.
 %s: bad argument %s: %s
 %s: error reading from stdin: %s
 %s: expired authentication tokens updated successfully.
 %s: libuser initialization error: %s: unable to set failure delay: %s
 %s: unable to set tty for pam: %s
 %s: unable to start pam: %s
 %s: user account has no support for password aging.
 Adjusting aging data for user %s.
 Alternate authentication scheme in use. Changing password for user %s.
 Corrupted passwd entry. Empty password. Error Error (password not set?) Expiring password for user %s.
 Locking password for user %s.
 No password set.
 Note: deleting a password also unlocks the password. Only root can do that.
 Password locked. Password set, DES crypt. Password set, MD5 crypt. Password set, SHA256 crypt. Password set, SHA512 crypt. Password set, blowfish crypt. Password set, unknown crypt variant. Removing password for user %s.
 Success Unknown user.
 Unlocking password for user %s.
 Unsafe operation (use -f to force) Warning: unlocked password would be empty. [OPTION...] <accountName> delete the password for the named account (root only); also removes password lock if any expire the password for the named account (root only) force operation keep non-expired authentication tokens lock the password for the named account (root only) maximum password lifetime (root only) minimum password lifetime (root only) number of days after password expiration when an account becomes disabled (root only) number of days warning users receives before password expiration (root only) read new tokens from stdin (root only) report password status on the named account (root only) unlock the password for the named account (root only) Project-Id-Version: passwd 0.79
Report-Msgid-Bugs-To: http://bugzilla.redhat.com/
POT-Creation-Date: 2018-04-01 02:30+0200
PO-Revision-Date: 2017-04-01 03:29-0400
Last-Translator: Copied by Zanata <copied-by-zanata@zanata.org>
Language-Team: Hungarian <trans-hu@lists.fedoraproject.org>
Language: hu
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
X-Generator: Zanata 3.9.6
 %s: Ön nem azonosítható!
 %s: Az -l, -u, -d, -S kapcsolók egyikét sem lehet keverni ezekkel: -i, -n, -w, -x.
 %s: Az -l, -u, -d, -S kapcsolókból csak az egyiket szabad megadni.
 %s: Csak egy felhasználónevet szabad megadni.
 %s: Csak a rendszergazda adhat meg felhasználónevet.
 %s: az SELinux megtagadja a hozzáférést a biztonsági szabályok miatt.
 %s: A megadott felhasználónév túl hosszú.
 %s: Ez a kapcsoló egy felhasználónevet igényel.
 %s: ismeretlen felhasználónév: „%s”.
 %s: minden hitelesítési jegy frissítése sikerült.
 %s: hibás argumentum: %s: %s
 %s: hiba a szabványos bemenet olvasásakor: %s
 %s: a lejárt hitelesítési jegyek frissítése sikerült.
 %s: libuser előkészítési hiba: %s: nem lehet hibakésleltetést beállítani: %s
 %s: nem lehet tty-t beállítani a PAM-hoz: %s
 %s: a PAM nem indítható: %s
 %s: a felhasználó fiókja nem támogatja a határidős jelszavakat.
 %s felhasználó lejárati adatainak beállítása.
 Váltakozó hitelesítési séma van használatban. %s felhasználó jelszavának megváltoztatása.
 Sérült jelszó bejegyzés. Üres jelszó. Hiba Hiba (nincs jelszó beállítva?) %s felhasználó jelszavának lejártnak jelölése.
 %s felhasználó jelszavának zárolása.
 Nincs jelszó beállítva.
 Megjegyzés: egy jelszó törlése fel is oldja azt. Ezt csak a rendszergazda teheti meg.
 Jelszó zárolva. Jelszó beállítva, DES-titkosítás. Jelszó beállítva, MD5-titkosítás. Jelszó beállítva, SHA256 titkosítás. Jelszó beállítva, SHA512 titkosítás. Jelszó beállítva, Blowfish-titkosítás. Jelszó beállítva, ismeretlen titkosítási változat. %s felhasználó jelszavának eltávolítása.
 Sikerült Ismeretlen felhasználó.
 %s felhasználó jelszavának feloldása.
 Nem biztonságos művelet (-f a kikényszerítéshez) Figyelmeztetés: a feloldott jelszó üres lenne. [KAPCSOLÓ…] <fiókNév> a nevezett felhasználó jelszavának törlése (csak rendszergazda), valamint az esetleges jelszózár eltávolítása a jelszó lejártnak jelölése a nevezett felhasználónál (csak rendszergazda) művelet kikényszerítése nem lejárt hitelesítési jegyek megtartása a jelszó zárolása a nevezett felhasználónál (csak rendszergazda) jelszó maximális érvényessége (csak rendszergazda) jelszó minimális érvényessége (csak rendszergazda) jelszó lejárta utáni napok száma, amikortól a fiók letiltásra kerül (csak rendszergazda) jelszó lejárta előtti napok száma, amikortól figyelmeztetést kap a felhasználó (csak rendszergazda) új jegyek beolvasása a szabványos bemenetről (csak rendszergazda) jelentés a nevezett felhasználó jelszavának állapotáról (csak rendszergazda) a jelszó feloldása a nevezett felhasználónál (csak rendszergazda) 