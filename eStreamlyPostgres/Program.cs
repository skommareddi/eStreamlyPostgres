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
            var connectionString = args.FirstOrDefault() ?? "User ID=postgres;Password=admin@123;Host=localhost;Port=5432;Database=estreamly;Pooling=true;Integrated Security=true;";

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
