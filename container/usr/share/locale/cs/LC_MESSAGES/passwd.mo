��    9      �  O   �      �     �  @     1   E  )   w  '   �  3   �  (   �  &   &     M  4   j     �  !   �  8   �  !     $   5  "   Z     }  4   �  "   �  '   �          :     R     b     h     �     �     �  4   �     	      	     1	     J	     c	     	     �	  $   �	     �	     �	     
      
  "   6
  *   Y
     �
  X   �
  5   �
     -  &   =  3   d  %   �  %   �  U   �  L   :  &   �  7   �  5   �  �    %   	  I   /  ?   y  0   �  0   �  E     7   a  /   �     �  ?   �     (     F  I   f  (   �  2   �  #        0  =   O  /   �  &   �     �  %        '     8     >  *   ]      �     �  +   �  '   �       "   &  "   I  %   l  %   �  '   �  (   �     	     )     2      H  .   i  *   �     �  X   �  5   7     m  2   }  -   �  -   �  -     I   :  P   �  )   �  /   �  -   /             '   +   8          &   5               *       (                 .   3      $   1         #                        %         /                        2             7       ,   -   )                    	       "       9           
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
PO-Revision-Date: 2015-05-23 01:04-0400
Last-Translator: Miloslav Trmač <mitr@redhat.com>
Language-Team: Czech (http://www.transifex.com/projects/p/fedora/language/cs/)
Language: cs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=3; plural=(n==1) ? 0 : (n>=2 && n<=4) ? 1 : 2;
X-Generator: Zanata 3.9.6
 %s: Není možno vás identifikovat!
 %s: Nelze použít současně -l, -u, -d, -S s parametry -i, -n, -w, -x.
 %s: Pouze jeden z parametrů -l, -u, -d, -S smí být použit.
 %s: Lze zadat pouze jedno uživatelské jméno.
 %s: Pouze root smí zadat uživatelské jméno.
 %s: SELinux na základě bezpečnostní politiky zakázal přístup.
 %s: Zadané uživatelské jméno je příliš dlouhé.
 %s: Tato volba vyžaduje uživatelské jméno.
 %s: Neznámý uživatel '%s'.
 %s: všechny autentizační tokeny byly úspěšně změněny.
 %s: špatný parametr %s: %s
 %s: chyba čtení ze stdin: %s
 %s: autentizační tokeny, které vypršely, byly úspěšně změněny.
 %s: chyba inicializace knihovny libuser: %s: nelze nastavit dobu čekání při chybě: %s
 %s: nelze nastavit tty pro pam: %s
 %s: nelze nastartovat pam: %s
 %s: uživatelský účet nemá podporu pro stárnutí hesla.
 Nastavení dat stárnutí hesla uživatele %s.
 Použito jiné autentizační schéma. Změna hesla uživatele %s.
 Poškozený záznam v souboru passwd. Prázdné heslo. Chyba Chyba (heslo není nastaveno?) Vypršení platnosti hesla uživatele %s.
 Uzamčení hesla uživatele %s.
 Heslo není nastaveno.
 Pozor: zrušení hesla také heslo odemkne. Tuto operaci smí provést pouze root.
 Zamčené heslo. Heslo nastaveno, šifrování DES. Heslo nastaveno, šifrování MD5. Heslo nastaveno, šifrování SHA256. Heslo nastaveno, šifrování SHA512. Heslo nastaveno, šifrování blowfish. Heslo nastaveno, neznámé šifrování. Zrušení hesla uživatele %s.
 Úspěch Neznámý uživatel.
 Odemčení hesla uživatele %s.
 Nebezpečná operace (vynutitelná pomocí -f) Pozor: odemčené heslo by bylo prázdné. [VOLBA...] <název-účtu> zrušit heslo zadaného účtu (pouze root); také odstraní případné zamknutí hesla vypršet platnost hesla zadaného účtu (pouze root) vynutit operaci ponechat autentizační tokeny, které nevypršely uzamknout heslo zadaného účtu (pouze root) maximální doba platnosti hesla (pouze root) minimální doba platnosti hesla (pouze root) počet dní po vypršení hesla, kdy bude účet zablokován (pouze root) počet dní zobrazení varování před vypršením platnosti hesla (pouze root) číst nové tokeny ze stdin (pouze root) zobrazit stav hesla daného účtu (pouze root) odemknout heslo zadaného účtu (pouze root) 