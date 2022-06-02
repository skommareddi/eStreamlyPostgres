using DbUp;
using System;
using System.Linq;
using System.Reflection;

namespace eStreamlyPostgres
{
    internal class Program
    {
        static int Main(string[] args)
        {
            // "User ID=iresponsive@dbestreamly-dev;Password=Te@m$pirit01;Host=dbestreamly-dev.postgres.database.azure.com;Port=5432;Database=dev-dbestreamly;Pooling=true;Integrated Security=true;SslMode=Require;";
            // "User ID=postgres;Password=admin@123;Host=localhost;Port=5432;Database=estreamly;Pooling=true;Integrated Security=true;"
            var connectionString = args.FirstOrDefault() ?? "User ID=iresponsive@dbestreamly-dev;Password=Te@m$pirit01;Host=dbestreamly-dev.postgres.database.azure.com;Port=5432;Database=dbestreamly;Pooling=true;Integrated Security=true;SslMode=Require;";

            var upgrader = DeployChanges.To
                    .PostgresqlDatabase(connectionString)
                    .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                    .LogToConsole()
                    .Build();

            var result = upgrader.PerformUpgrade();

            if (!result.Successful)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(result.Error);
                Console.ResetColor();
#if DEBUG
                Console.ReadLine();
#endif
                return -1;
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Success!");
            Console.ResetColor();
            return 0;
        }
    }
}
