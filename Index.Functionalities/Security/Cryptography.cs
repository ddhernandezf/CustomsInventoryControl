using System;
using System.Security.Cryptography;
using System.Text;

namespace Index.Functionalities.Security
{
    public static class Cryptography
    {
        #region PrivateProperties
        private static readonly string magicWord = "R&MINDEX";
        private static TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
        private static MD5CryptoServiceProvider md5cc = new MD5CryptoServiceProvider();
        #endregion

        #region Privates
        private static byte[] Md5Hash(string str)
        {
            return md5cc.ComputeHash(ASCIIEncoding.ASCII.GetBytes(str));
        }

        private static void DefineDes(string strMagic)
        {
            des.Key = Md5Hash(strMagic);
            des.Mode = CipherMode.ECB;
        }
        #endregion

        #region Publics
        public static String Encrypt(this string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return string.Empty;
            }

            DefineDes(magicWord);

            str = str.Replace("á", "-/&$ta$&/-")
           .Replace("é", "-/&$tecu$&/-")
           .Replace("í", "-/&$ticu$&/-")
           .Replace("ó", "-/&$tocu$&/-")
           .Replace("ú", "-/&$tucu$&/-")
           .Replace("ñ", "-/&$tncu$&/-")
           .Replace("ü", "-/&$tuumcu$&/-")
           .Replace("Á", "-/&$tAcu$&/-")
           .Replace("É", "-/&$tEcu$&/-")
           .Replace("Í", "-/&$tIcu$&/-")
           .Replace("Ó", "-/&$tOcu$&/-")
           .Replace("Ú", "-/&$tUcu$&/-")
           .Replace("Ñ", "-/&$tNcu$&/-")
           .Replace("Ü", "-/&$tUumcu$&/-");



            byte[] buffer = ASCIIEncoding.ASCII.GetBytes(str);
            string result = Convert.ToBase64String(des.CreateEncryptor().TransformFinalBlock(buffer, 0, buffer.Length));

            return result.Replace("+", "(m)")
           .Replace("=", "(i)")
           .Replace("/", "(d1)")
           .Replace(@"\", "(d2)");
        }
        public static String Decrypt(this string str)
        {
            if (string.IsNullOrEmpty(str))
            {
                return string.Empty;
            }

            str = str.Replace(" ", "+");
            DefineDes(magicWord);
            str = str.Replace("(m)", "+")
           .Replace("(i)", "=")
           .Replace("(d1)", "/")
           .Replace("(d2)", @"(\)");

            byte[] buffer = Convert.FromBase64String(str);
            str = ASCIIEncoding.ASCII.GetString(des.CreateDecryptor().TransformFinalBlock(buffer, 0, buffer.Length));

            str = str
           .Replace("-/&$ta$&/-", "á")
           .Replace("-/&$tecu$&/-", "é")
           .Replace("-/&$ticu$&/-", "í")
           .Replace("-/&$tocu$&/-", "ó")
           .Replace("-/&$tucu$&/-", "ú")
           .Replace("-/&$tncu$&/-", "ñ")
           .Replace("-/&$tuumcu$&/-", "ü")
           .Replace("-/&$tAcu$&/-", "Á")
           .Replace("-/&$tEcu$&/-", "É")
           .Replace("-/&$tIcu$&/-", "Í")
           .Replace("-/&$tOcu$&/-", "Ó")
           .Replace("-/&$tUcu$&/-", "Ú")
           .Replace("-/&$tNcu$&/-", "Ñ")
           .Replace("-/&$tUumcu$&/-", "Ü");


            return str.Trim();
        }
        #endregion
    }
}
