using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Index.Testing.Functionalities
{
    [TestClass]
    public class Crypto
    {
        [TestMethod]
        public void TestMethod1()
        {
            String result = Index.Functionalities.Security.Cryptography.Decrypt("yt9Dx42ReyE(m)KODNq7(m)(d1)uA(i)(i)");

            Assert.IsNotNull(result);
        }
    }
}
