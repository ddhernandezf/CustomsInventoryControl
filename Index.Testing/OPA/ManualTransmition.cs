using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Index.Queue.OpaService;
using Index.Queue;

namespace Index.Testing.OPA
{
    [TestClass]
    public class ManualTransmition
    {
        [TestMethod]
        public void TestMethod1()
        {
            OpaExternal opaSvc = new OpaExternal("uIndex", "Index0707Ws", "https://sws.export.com.gt/WS_OPA_2015/WSOPA.asmx");
            clsRespuestaDescargo r1 = new clsRespuestaDescargo(), r2 = new clsRespuestaDescargo(), r3 = new clsRespuestaDescargo();
            r1 = opaSvc.Validate("4908811-4", "274-6504971", 1, 9.578800, "9157397314", 1);
            r2 = opaSvc.Validate("4908811-4", "274-6506473", 1, 16.800000, "9157397314", 1);
            r2 = opaSvc.Validate("4908811-4", "274-6507238", 1, 1713.600000, "9157397314", 1);
        }

        [TestMethod]
        public void TestMethod2()
        {
            OpaExternal opaSvc = new OpaExternal("uIndex", "Index0707Ws", "https://sws.export.com.gt/Desa/WS_OPA_2015/WSOPA.asmx");
            clsRespuestaDescargo r1 = new clsRespuestaDescargo(), r2 = new clsRespuestaDescargo(), r3 = new clsRespuestaDescargo();
            r1 = opaSvc.Validate("8851821-3", "274-6500634", 1, 9.578800, "915-6690865", 1);
        }
    }
}
