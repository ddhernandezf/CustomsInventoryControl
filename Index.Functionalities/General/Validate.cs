using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Functionalities.General
{
    public static class Validate
    {
        public static Boolean Nit(String pStrNit)
        {
            Boolean result = false;

            try
            {
                if (!String.IsNullOrEmpty(pStrNit) || !String.IsNullOrWhiteSpace(pStrNit))
                {
                    pStrNit = pStrNit.Replace("-", "");
                    Int32 lastChar = pStrNit.Length - 1;
                    String number = pStrNit.Substring(0, lastChar);
                    String expectedCheker = pStrNit[lastChar].ToString().ToLower();
                    Int32 factor = number.Length + 1;
                    Int32 total = 0;

                    for (int i = 0; i < number.Length; i++)
                    {
                        String character = number[i].ToString();
                        Int32 digit = Convert.ToInt32(character);

                        total += (digit * factor);
                        factor = factor - 1;
                    }

                    var modulus = (11 - (total % 11)) % 11;
                    var computedChecker = (modulus == 10 ? "k" : modulus.ToString());
                    if (expectedCheker == computedChecker)
                    {
                        result = true;
                    }
                }

                return result;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
