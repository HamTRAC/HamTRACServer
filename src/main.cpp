#include <cstdlib>
#include <cstring>
#include <iostream>
#include <map>
#include <string>
#include <vector>

#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>

using namespace rapidjson;

void json_example() {
  const char *json = "{\"project\":\"rapidjson\",\"stars\":10}";
  Document    d;
  d.Parse(json);

  // 2. Modify it by DOM.
  Value &s = d["stars"];
  s.SetInt(s.GetInt() + 1);

  // 3. Stringify the DOM
  StringBuffer         buffer;
  Writer<StringBuffer> writer(buffer);
  d.Accept(writer);

  // Output {"project":"rapidjson","stars":11}
  std::cout << buffer.GetString() << std::endl;
}

int main(int argc, char *argv[]) {
  std::cout << "Hello World!" << std::endl;

  json_example();

  return 0;
}
