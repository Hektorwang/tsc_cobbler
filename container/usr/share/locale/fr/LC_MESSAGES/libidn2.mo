��    $      <  5   \      0     1  R  >  N   �  &   �  O        W  #   e  !   �  *   �  D   �  @     %   \  &   �  &   �  (   �     �             (   .  '   W  4     4   �  &   �  /     /   @  7   p  -   �  %   �  %   �  "   "	     E	  .   [	  #   �	  '   �	     �	  �  �	     �  �  �  =   �  3   �  G        e  ,   u  +   �  2   �  G     E   I  5   �  *   �  )   �  6     #   Q     u     �  2   �  /   �  A   �  A   >  *   �  4   �  4   �  B     /   X  5   �  :   �  *   �     $  A   C  *   �  6   �     �                          !                                                           
                                    $              #                 "   	                         Charset: %s
 Command line interface to the Libidn2 implementation of IDNA2008.

All strings are expected to be encoded in the locale charset.

To process a string that starts with `-', for example `-foo', use `--'
to signal the end of parameters, as in `idn2 --quiet -- -foo'.

Mandatory arguments to long options are mandatory for short options too.
 Internationalized Domain Name (IDNA2008) convert STRINGS, or standard input.

 Try `%s --help' for more information.
 Type each input string on a line by itself, terminated by a newline character.
 Unknown error Usage: %s [OPTION]... [STRINGS]...
 could not convert string to UTF-8 could not determine locale encoding format domain label has character forbidden in non-transitional mode (TR46) domain label has character forbidden in transitional mode (TR46) domain label has forbidden dot (TR46) domain label longer than 63 characters domain name longer than 255 characters input A-label and U-label does not match input A-label is not valid input error out of memory punycode conversion resulted in overflow punycode encoded data will be too large string contains a context-j character with null rule string contains a context-o character with null rule string contains a disallowed character string contains a forbidden context-j character string contains a forbidden context-o character string contains a forbidden leading combining character string contains forbidden two hyphens pattern string contains invalid punycode data string contains unassigned code point string could not be NFC normalized string encoding error string has forbidden bi-directional properties string is not in Unicode NFC format string start/ends with forbidden hyphen success Project-Id-Version: GNU libidn2-2.1.1
Report-Msgid-Bugs-To: bug-libidn2@gnu.org
PO-Revision-Date: 2019-02-12 20:40+0100
Last-Translator: Jean-Philippe Guérard <jean-philippe.guerard@corbeaunoir.org>
Language-Team: French <traduc@traduc.org>
Language: fr
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Bugs: Report translation errors to the Language-Team address.
Plural-Forms: nplurals=2; plural=(n > 1);
 Jeu de caractères « %s ».
 Interface en ligne de commande de la mise en œuvre libidn2 de IDNA2008.

Toutes les chaînes sont supposées être codées avec le jeu de
caractère principal de vos paramètres régionaux (les « locales »).

Pour traiter une chaîne commençant par « - », comme « -foo »,
utilisez « -- » pour indiquer la fin des options. Par exemple :
« idn2 --quiet -- -foo ».

Les arguments obligatoires des options longues sont également
obligatoires pour les options courtes.
 IDN (IDNA2008) converti des CHAÎNES ou l'entrée standard.

 Essayez « %s --help » pour plus d'information.
 Saisissez une chaîne par ligne, terminée par un passage à la ligne.
 Erreur inconnue Utilisation : %s [OPTION]... [CHAÎNES]...
 impossible de convertir la chaîne en UTF-8 impossible de déterminer le codage local utilisé le label contient un caractère interdit en mode hors transition (TR46) le label contient un caractère interdit en mode de transition (TR46) le label du domaine contient un point interdit (TR46) label du domaine dépassant 63 caractères nom de domaine dépassant 255 caractères les A-label et U-label en entrée ne correspondent pas le A-label en entrée est incorrect entrée erronée mémoire épuisée la conversion punycode a provoqué un débordement les données punycodes seront trop volumineuses la chaîne contient un caractère context-j avec une règle nulle la chaîne contient un caractère context-o avec une règle nulle la chaîne contient un caractère interdit la chaîne contient un caractère context-j interdit la chaîne contient un caractère context-o interdit la chaîne ne doit pas contenir de caractère combinatoire initial la chaîne ne doit pas contenir de double tiret la chaîne contient des données punycode incorrectes la chaîne contient un numéro de caractère non attribué normalisation NFC de la chaîne impossible erreur de codage de la chaîne la chaîne contient des propriétés bidirectionnelles interdites la chaîne n'est pas en codage NFC Unicode la chaîne ne doit pas commencer ou finir par un tiret succès 