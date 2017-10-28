using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace RenameMeToWhatever
{
	// Install-Package Microsoft.Net.Http
	// Install-Package Microsoft.Bcl.Async

	[DataContract]
	public class Result<T>
	{
		[DataMember]
		public T Obj;

		[DataMember]
		public string Error;

		[DataMember]
		public int ErrorCode;
	}

	public class ServiceException : Exception
	{
		readonly int _code;

		public int Code { get { return _code; } }

		public ServiceException()
		{
			_code = -1;
		}

		public ServiceException(string message, int code)
			: base(message)
		{
			_code = code;
		}

		public ServiceException(string message, int code, Exception inner)
			: base(message, inner)
		{
			_code = code;
		}
	}

	public partial class Service
	{
		private string _sessionId;

		public string SessionId 
		{
			get { return _sessionId; }
			set { _sessionId = value; }
		}

		public async Task<T> Call<T>(Dictionary<string, object> args, CancellationToken? ct = null)
		{
			StringBuilder sb = new StringBuilder();

			foreach(var arg in args)
			{
				if(arg.Value != null)
				{
					sb.Append(arg.Key + "=" + Uri.EscapeDataString(arg.Value.ToString()) + "&");
				}
			}

			if(_sessionId != null && !args.ContainsKey("sessionId"))
			{
				sb.Append("sessionId=" + Uri.EscapeDataString(_sessionId) + "&");
			}

			sb.Append("__DOTNET__=1");

			using(HttpClientHandler handler = new HttpClientHandler())
			{
				using(HttpClient client = new HttpClient(handler))
				{
					if(handler.SupportsAutomaticDecompression)
					{
						handler.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;
					}

					using(HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, "%URL%"))
					{
						request.Content = new StringContent(sb.ToString(), Encoding.UTF8, "application/x-www-form-urlencoded");

						HttpResponseMessage response;

						if(ct.HasValue)
						{
							response = await client.SendAsync(request, ct.Value);
						}
						else
						{
							response = await client.SendAsync(request);
						}

						Stream s = await response.Content.ReadAsStreamAsync();

						if(!response.IsSuccessStatusCode)
						{
							using(var reader = new StreamReader(s))
							{
								throw new Exception(String.Format("{0} {1}", (int)response.StatusCode, response.ReasonPhrase)); // reader.ReadToEnd();
							}
						}

						DataContractJsonSerializer ser = new DataContractJsonSerializer(typeof(Result<T>));

						Result<T> result = (Result<T>)ser.ReadObject(s);

						if(result.Error != null)
						{
							throw new ServiceException(result.Error, result.ErrorCode);
						}

						object method;

						if(args.TryGetValue("method", out method) && (string)method == "InitiateSession")
						{
							_sessionId = result.Obj as string;
						}

						return result.Obj;
					}
				}
			}
		}

%DEFS%
	}

%DECL%
}
