��    9      �  O   �      �     �  @     1   E  )   w  '   �  3   �  (   �  &   &     M  4   j     �  !   �  8   �  !     $   5  "   Z     }  4   �  "   �  '   �          :     R     b     h     �     �     �  4   �     	      	     1	     J	     c	     	     �	  $   �	     �	     �	     
      
  "   6
  *   Y
     �
  X   �
  5   �
     -  &   =  3   d  %   �  %   �  U   �  L   :  &   �  7   �  5   �  �       �  R   
  :   ]  *   �  -   �  /   �     !  -   @  )   n  -   �     �  *   �  -        =  #   ]  #   �     �  -   �  &   �  !         8     Y     t     �  '   �  )   �      �     �  0        C     `  "   s  "   �  %   �  %   �  '     *   -      X     y     �      �  .   �  *   �       ]   )  6   �     �     �  3   �  -     -   L  H   z  E   �  4   	  <   >  9   {             '   +   8          &   5               *       (                 .   3      $   1         #                        %         /                        2             7       ,   -   )                    	       "       9           
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
PO-Revision-Date: 2017-09-06 04:35-0400
Last-Translator: Copied by Zanata <copied-by-zanata@zanata.org>
Language-Team: Chinese (Taiwan) <trans-zh_TW@lists.fedoraproject.org>
Language: zh_TW
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Generator: Zanata 3.9.6
 %s：無法辨識出您！
 %s：無法同時使用一個 -l、-u、-d、-S 以及一個 -i、-n、-w、-x。
 %s：只可指定 -l、-u、-d、-S 中的其中一個。
 %s：只可指定一組使用者名稱。
 %s：只有 root 可指定使用者名稱。
 %s：SELinux 由於安全方針拒絕存取。
 %s：使用者名稱過長。
 %s：此選項需要一組使用者名稱。
 %s：不明的使用者名稱「%s」。
 %s：所有核對代符都已成功更新。
 %s：無效的引數 %s：%s
 %s：由 stdin 讀取時發生錯誤：%s
 %s：已成功更新過期的核對代符。
 %s：libuser 初始化錯誤： %s：無法設定失敗延遲：%s
 %s：無法為 pam 設定 tty：%s
 %s：無法啟用 pam：%s
 %s：使用者帳號不支援密碼限期。
 調整使用者 %s 的期限資料。
 其它驗證格式正使用中。 更改使用者 %s 的密碼。
 損毀的 passwd 條目。 空白密碼。 錯誤 錯誤（密碼是否尚未設定？） 正在讓使用者 %s 的密碼過期。
 鎖定使用者 %s 的密碼。
 密碼未設定。
 備註：刪除密碼也會解除密碼鎖定。 只有 root 可這麼作。
 密碼已鎖定。 密碼已設定，DES 加密法。 密碼已設定，MD5 加密法。 密碼已設定，SHA256 加密法。 密碼已設定，SHA512 加密法。 密碼已設定，blowfish 加密法。 密碼已設定，不明的加密類型。 移除使用者 %s 的密碼。
 成功 未知使用者。
 解開使用者 %s 的密碼。
 不安全的作業（使用 -f 強制執行） 警告：未鎖定的密碼將會空白。 [OPTION...] <accountName> 刪除已有命名帳號的密碼（僅限 root 執行）；若有的話也移除密碼鎖定 讓已命名帳號的密碼過期 (僅限 root 執行) 強制作業 保留未過期的驗證代符 鎖住已命名帳號的密碼 (僅限 root 執行) 最大密碼有效期限 (僅限 root 執行) 最小密碼有效期限 (僅限 root 執行) 帳號在密碼過期後即將被停用前的天數 (僅限 root 執行) 使用者在密碼過期前收到警告的天數 (僅限 root 執行) 由 stdin 讀取新的代符（僅限 root 執行） 回報已命名帳號上的密碼狀態 (僅限 root 執行) 解開已命名帳號的密碼鎖定 (僅限 root 執行) 