#include <iostream>

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>

#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>

int main(int, char **) {
  mongocxx::instance inst{};
  mongocxx::options::client opts;
  mongocxx::options::ssl ssl_opts;
  ssl_opts.allow_invalid_certificates(true);
  opts.ssl_opts(ssl_opts);
  mongocxx::client conn{mongocxx::uri{"mongo://127.0.0.1:9017/test"}, opts};

  bsoncxx::builder::stream::document document{};

  auto collection = conn["testdb"]["testcollection"];
  document << "hello"
           << "world";

  collection.insert_one(document.view());
  auto cursor = collection.find({});

  for (auto &&doc : cursor) {
    std::cout << bsoncxx::to_json(doc) << std::endl;
  }
}
