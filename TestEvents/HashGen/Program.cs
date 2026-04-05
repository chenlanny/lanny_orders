using System;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Generating BCrypt hashes...");
        Console.WriteLine($"111: {BCrypt.Net.BCrypt.HashPassword("111")}");
        Console.WriteLine($"222: {BCrypt.Net.BCrypt.HashPassword("222")}");
        Console.WriteLine($"333: {BCrypt.Net.BCrypt.HashPassword("333")}");
        Console.WriteLine($"444: {BCrypt.Net.BCrypt.HashPassword("444")}");
        Console.WriteLine($"555: {BCrypt.Net.BCrypt.HashPassword("555")}");
    }
}
