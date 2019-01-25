using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Timers;
using Index.Dal;
using Index.Queue;

namespace ConsoleTesting
{
    public class Program
    {
        public static Boolean exec = true;
        public static Int32 Delay = 0;
        public static Boolean BlockProccess = false;
        public static Index.Commons.Parameters Params = new Index.Commons.Parameters();
        
        static void Main(string[] args)
        {
            if (Program.exec == true)
            {
                Timer svcTimer = new Timer();
                Params = Parameters.Get();
                Int32 mlsecons = Params.OpaFrecuencySeconds * 1000;
                Program.Delay = Params.OpaDelaySeconds * 1000;
                svcTimer = new Timer(mlsecons);

                Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Configurando el proceso.");
                svcTimer.Elapsed += new ElapsedEventHandler(svcTimer_Elapsed);
                Program.exec = false;
                svcTimer.Start();

                //Main(args);
                if (Console.ReadLine().ToUpper() != "EXIT")
                {
                    Console.ReadLine();
                }
            }
        }

        static void svcTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            if (!Program.BlockProccess)
            {
                OpaExternal opaSvc = new OpaExternal(Params.OpaServiceUser, Params.OpaServicePassword, Params.OpaServiceUrl);
                spg_Queue_Result batch = Opa.GetDocumentToProccess();

                if (!Opa.IsProccessExists())
                {
                    if (batch == null)
                    {
                        Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") +  " La cola se encuentra vacía");
                    }
                    else
                    {
                        Console.WriteLine("");
                        Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Iniciando el proceso con cola número: " + batch.IdOpaHeader);
                        Opa.SetDocumentToProccess(batch);
                        Opa.Proccess(opaSvc, ref Program.BlockProccess, Program.Delay, batch);
                        Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Finalizando el proceso con cola número: " + batch.IdOpaHeader);
                        Console.WriteLine("");
                    }
                }
                else
                {
                    if (batch != null)
                    {
                        Console.WriteLine("");
                        Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Iniciando el proceso con cola número: " + batch.IdOpaHeader);
                        Opa.Proccess(opaSvc, ref Program.BlockProccess, Program.Delay, batch);
                        Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Finalizando el proceso con cola número: " + batch.IdOpaHeader);
                        Console.WriteLine("");
                    }
                }
            }
        }
    }
}
