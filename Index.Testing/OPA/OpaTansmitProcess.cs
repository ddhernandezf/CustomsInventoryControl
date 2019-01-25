using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Timers;
using Index.Dal;

namespace Index.Testing.OPA
{
    [TestClass]
    public class OpaTansmitProcess
    {
        Timer svcTimer = new Timer();

        [TestMethod]
        public void QueueProccess()
        {
            Int32 mlsecons = Parameters.Get().OpaFrecuencySeconds * 1000;
            svcTimer = new Timer(mlsecons);
            svcTimer.Elapsed += new ElapsedEventHandler(svcTimer_Elapsed);

            svcTimer.Start();
        }

        void svcTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            Console.WriteLine("corre cada 10 segundos");
        }
    }
}
