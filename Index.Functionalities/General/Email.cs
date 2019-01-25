using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;

namespace Index.Functionalities.General
{
    public class Email
    {
        public String User { get; set; }
        public String Password { get; set; }
        public String SMTP { get; set; }
        public Int32 Port { get; set; }
        public Boolean UseSsl { get; set; }
        private MailMessage Mail { get; set; }
        private SmtpClient MailServer { get; set; }

        public Email(String user, String password, String smtp, Int32 port, Boolean usessl, String displayname, Boolean IsHtml)
        {
            this.User = user;
            this.Password = password;
            this.SMTP = smtp;
            this.Port = port;
            this.UseSsl = usessl;

            this.Mail = new MailMessage();
            this.Mail.IsBodyHtml = IsHtml;
            if (string.IsNullOrEmpty(displayname) || String.IsNullOrWhiteSpace(displayname))
            {
                this.Mail.From = new MailAddress(this.User);
            }
            else
            {
                this.Mail.From = new MailAddress(this.User, displayname);
            }

            this.MailServer = new SmtpClient(this.SMTP);
            this.MailServer.Port = this.Port;
            this.MailServer.UseDefaultCredentials = false;
            this.MailServer.Credentials = new System.Net.NetworkCredential(this.User, this.Password);
            this.MailServer.EnableSsl = this.UseSsl;
        }

        public void BuildMessage(String email, String cc, String cco, String subject, String Body)
        {
            if (String.IsNullOrEmpty(email) || String.IsNullOrWhiteSpace(email))
            {
                throw new Exception("El email se encuentra vacío");
            }

            this.Mail.To.Add(email);

            if (!String.IsNullOrEmpty(cc) || !String.IsNullOrWhiteSpace(cc))
            {
                this.Mail.CC.Add(cc);
            }

            if (!String.IsNullOrEmpty(cco) || !String.IsNullOrWhiteSpace(cco))
            {
                this.Mail.CC.Add(cco);
            }

            this.Mail.Subject = subject;
            this.Mail.Body = Body;
        }

        public void BuildMessage(List<String> emailList, List<String> ccList, List<String> ccoList, String subject, String Body)
        {
            if (emailList == null || emailList.Count == 0)
            {
                throw new Exception("No se agrego ningun correo electrónico");
            }

            foreach (String email in emailList)
            {
                this.Mail.To.Add(email);
            }

            if (ccList != null)
            {
                foreach (String cc in ccList)
                {
                    if(!String.IsNullOrEmpty(cc) || !String.IsNullOrWhiteSpace(cc))
                    {
                        this.Mail.CC.Add(cc);
                    }
                }
            }

            if (ccoList != null)
            {
                foreach (String cco in ccoList)
                {
                    if (!String.IsNullOrEmpty(cco) || !String.IsNullOrWhiteSpace(cco))
                    {
                        this.Mail.Bcc.Add(cco);
                    }
                }
            }

            this.Mail.Subject = subject;
            this.Mail.Body = Body;
        }

        public Boolean Send()
        {
            this.MailServer.Send(this.Mail);

            return true;
        }
    }
}
