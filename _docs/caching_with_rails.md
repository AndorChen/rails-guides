---
layout: docs
title: Rails 缓存简介
prev_section: command_line
next_section: asset_pipeline
---

本文要教你如果避免频繁查询数据库，在最短的时间内把真正需要的内容返回给客户端。

本完后，你将学会：

* 页面和动作缓存（在 Rails 4 中被提取成单独的 gem）；
* 片段缓存；
* 存储缓存的方法；
* Rails 对条件 GET 请求的支持；

---

Basic Caching
-------------

本节介绍三种缓存技术：页面，动作和片段。Rails 默认支持片段缓存。如果想使用页面缓存和动作缓存，要在 `Gemfile` 中加入 `actionpack-page_caching` 和 `actionpack-action_caching`。

在开发环境中若想使用缓存，要把 `config.action_controller.perform_caching` 选项设为 `true`。这个选项一般都在各环境的设置文件（`config/environments/*.rb`）中设置，在开发环境和测试环境默认是禁用的，在生产环境中默认是开启的。

{:lang="ruby"}
~~~
config.action_controller.perform_caching = true
~~~

### 页面缓存 {#page-caching}

页面缓存机制允许网页服务器（Apache 或 Nginx 等）直接处理请求，不经 Rails 处理。这么做显然速度超快，但并不适用于所有情况（例如需要身份认证的页面）。服务器直接从文件系统上伺服文件，所以缓存过期是一个很棘手的问题。

I> Rails 4 删除了对页面缓存的支持，如想使用就得安装 [actionpack-page_caching gem](https://github.com/rails/actionpack-page_caching)。最新推荐的缓存方法参见 [DHH 对键基缓存过期的介绍](http://37signals.com/svn/posts/3113-how-key-based-cache-expiration-works)。

### 动作缓存 {#action-caching}

如果动作上有前置过滤器就不能使用页面缓存，例如需要身份认证的页面，这时需要使用动作缓存。动作缓存和页面缓存的工作方式差不多，但请求还是会经由 Rails 处理，所以在伺服缓存之前会执行前置过滤器。使用动作缓存可以执行身份认证等限制，然后再从缓存中取出结果返回客户端。

I> Rails 4 删除了对动作缓存的支持，如想使用就得安装 [actionpack-action_caching gem](https://github.com/rails/actionpack-action_caching)。最新推荐的缓存方法参见 [DHH 对键基缓存过期的介绍](http://37signals.com/svn/posts/3113-how-key-based-cache-expiration-works)。

### 片段缓存 {#fragment-caching}

如果能缓存整个页面或动作的内容，再伺服给客户端，这个世界就完美了。但是，动态网页程序的页面一般都由很多部分组成，使用的缓存机制也不尽相同。在动态生成的页面中，不同的内容要使用不同的缓存方式和过期日期。为此，Rails 提供了一种缓存机制叫做“片段缓存”。

片段缓存把视图逻辑的一部分打包放在 `cache` 块中，后续请求都会从缓存中伺服这部分内容。

例如，如果想实时显示网站的订单，而且不想缓存这部分内容，但想缓存显示所有可选商品的部分，就可以使用下面这段代码：

{:lang="erb"}
~~~
<% Order.find_recent.each do |o| %>
  <%= o.buyer.name %> bought <%= o.product.name %>
<% end %>

<% cache do %>
  All available products:
  <% Product.all.each do |p| %>
    <%= link_to p.name, product_url(p) %>
  <% end %>
<% end %>
~~~

上述代码中的 `cache` 块会绑定到调用它的动作上，输出到动作缓存的所在位置。因此，如果要在动作中使用多个片段缓存，就要使用 `action_suffix` 为 `cache` 块指定前缀：

{:lang="erb"}
~~~
<% cache(action: 'recent', action_suffix: 'all_products') do %>
  All available products:
~~~

`expire_fragment` 方法可以把缓存设为过期，例如：

{:lang="ruby"}
~~~
expire_fragment(controller: 'products', action: 'recent', action_suffix: 'all_products')
~~~

如果不想把缓存绑定到调用它的动作上，调用 `cahce` 方法时可以使用全局片段名：

{:lang="erb"}
~~~
<% cache('all_available_products') do %>
  All available products:
<% end %>
~~~

在 `ProductsController` 的所有动作中都可以使用片段名调用这个片段缓存，而且过期的设置方式不变：

{:lang="ruby"}
~~~
expire_fragment('all_available_products')
~~~

如果不想手动设置片段缓存过期，而想每次更新商品后自动过期，可以定义一个帮助方法：

{:lang="ruby"}
~~~
module ProductsHelper
  def cache_key_for_products
    count          = Product.count
    max_updated_at = Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "products/all-#{count}-#{max_updated_at}"
  end
end
~~~

这个方法生成一个缓存键，用于所有商品的缓存。在视图中可以这么做：

{:lang="erb"}
~~~
<% cache(cache_key_for_products) do %>
  All available products:
<% end %>
~~~

如果想在满足某个条件时缓存片段，可以使用 `cache_if` 或 `cache_unless` 方法：

{:lang="erb"}
~~~
<% cache_if (condition, cache_key_for_products) do %>
  All available products:
<% end %>
~~~

缓存的键名还可使用 Active Record 模型：

{:lang="erb"}
~~~
<% Product.all.each do |p| %>
  <% cache(p) do %>
    <%= link_to p.name, product_url(p) %>
  <% end %>
<% end %>
~~~

Rails 会在模型上调用 `cache_key` 方法，返回一个字符串，例如 `products/23-20130109142513`。键名中包含模型名，ID 以及 `updated_at` 字段的时间戳。所以更新商品后会自动生成一个新片段缓存，因为键名变了。

上述两种缓存机制还可以结合在一起使用，这叫做“俄罗斯套娃缓存”（Russian Doll Caching）：

{:lang="erb"}
~~~
<% cache(cache_key_for_products) do %>
  All available products:
  <% Product.all.each do |p| %>
    <% cache(p) do %>
      <%= link_to p.name, product_url(p) %>
    <% end %>
  <% end %>
<% end %>
~~~

之所以叫“俄罗斯套娃缓存”，是因为嵌套了多个片段缓存。这种缓存的优点是，更新单个商品后，重新生成外层片段缓存时可以继续使用内层片段缓存。

### 低层缓存 {#low-level-caching}

有时不想缓存视图片段，只想缓存特定的值或者查询结果。Rails 中的缓存机制可以存储各种信息。

实现低层缓存最有效地方式是使用 `Rails.cache.fetch` 方法。这个方法既可以从缓存中读取数据，也可以把数据写入缓存。传入单个参数时，读取指定键对应的值。传入代码块时，会把代码块的计算结果存入缓存的指定键中，然后返回计算结果。

以下面的代码为例。程序中有个 `Product` 模型，其中定义了一个实例方法，用来查询竞争对手网站上的商品价格。这个方法的返回结果最好使用低层缓存：

{:lang="ruby"}
~~~
class Product < ActiveRecord::Base
  def competing_price
    Rails.cache.fetch("#{cache_key}/competing_price", expires_in: 12.hours) do
      Competitor::API.find_price(id)
    end
  end
end
~~~

I> 注意，在这个例子中使用了 `cache_key` 方法，所以得到的缓存键名是这种形式：`products/233-20140225082222765838000/competing_price`。`cache_key` 方法根据模型的 `id` 和 `updated_at` 属性生成键名。这是最常见的做法，因为商品更新后，缓存就失效了。一般情况下，使用低层缓存保存实例的相关信息时，都要生成缓存键。

### SQL 缓存 {#sql-caching}


Query caching is a Rails feature that caches the result set returned by each query so that if Rails encounters the same query again for that request, it will use the cached result set as opposed to running the query against the database again.

For example:

{:lang="ruby"}
~~~
class ProductsController < ApplicationController

  def index
    # Run a find query
    @products = Product.all

    ...

    # Run the same query again
    @products = Product.all
  end

end
~~~

Cache Stores
------------

Rails provides different stores for the cached data created by <b>action</b> and <b>fragment</b> caches.

TIP: Page caches are always stored on disk.

### Configuration

You can set up your application's default cache store by calling `config.cache_store=` in the Application definition inside your `config/application.rb` file or in an Application.configure block in an environment specific configuration file (i.e. `config/environments/*.rb`). The first argument will be the cache store to use and the rest of the argument will be passed as arguments to the cache store constructor.

{:lang="ruby"}
~~~
config.cache_store = :memory_store
~~~

NOTE: Alternatively, you can call `ActionController::Base.cache_store` outside of a configuration block.

You can access the cache by calling `Rails.cache`.

### ActiveSupport::Cache::Store

This class provides the foundation for interacting with the cache in Rails. This is an abstract class and you cannot use it on its own. Rather you must use a concrete implementation of the class tied to a storage engine. Rails ships with several implementations documented below.

The main methods to call are `read`, `write`, `delete`, `exist?`, and `fetch`. The fetch method takes a block and will either return an existing value from the cache, or evaluate the block and write the result to the cache if no value exists.

There are some common options used by all cache implementations. These can be passed to the constructor or the various methods to interact with entries.

* `:namespace` - This option can be used to create a namespace within the cache store. It is especially useful if your application shares a cache with other applications.

* `:compress` - This option can be used to indicate that compression should be used in the cache. This can be useful for transferring large cache entries over a slow network.

* `:compress_threshold` - This options is used in conjunction with the `:compress` option to indicate a threshold under which cache entries should not be compressed. This defaults to 16 kilobytes.

* `:expires_in` - This option sets an expiration time in seconds for the cache entry when it will be automatically removed from the cache.

* `:race_condition_ttl` - This option is used in conjunction with the `:expires_in` option. It will prevent race conditions when cache entries expire by preventing multiple processes from simultaneously regenerating the same entry (also known as the dog pile effect). This option sets the number of seconds that an expired entry can be reused while a new value is being regenerated. It's a good practice to set this value if you use the `:expires_in` option.

### ActiveSupport::Cache::MemoryStore

This cache store keeps entries in memory in the same Ruby process. The cache store has a bounded size specified by the `:size` options to the initializer (default is 32Mb). When the cache exceeds the allotted size, a cleanup will occur and the least recently used entries will be removed.

{:lang="ruby"}
~~~
config.cache_store = :memory_store, { size: 64.megabytes }
~~~

If you're running multiple Ruby on Rails server processes (which is the case if you're using mongrel_cluster or Phusion Passenger), then your Rails server process instances won't be able to share cache data with each other. This cache store is not appropriate for large application deployments, but can work well for small, low traffic sites with only a couple of server processes or for development and test environments.

### ActiveSupport::Cache::FileStore

This cache store uses the file system to store entries. The path to the directory where the store files will be stored must be specified when initializing the cache.

{:lang="ruby"}
~~~
config.cache_store = :file_store, "/path/to/cache/directory"
~~~

With this cache store, multiple server processes on the same host can share a cache. Servers processes running on different hosts could share a cache by using a shared file system, but that set up would not be ideal and is not recommended. The cache store is appropriate for low to medium traffic sites that are served off one or two hosts.

Note that the cache will grow until the disk is full unless you periodically clear out old entries.

This is the default cache store implementation.

### ActiveSupport::Cache::MemCacheStore

This cache store uses Danga's `memcached` server to provide a centralized cache for your application. Rails uses the bundled `dalli` gem by default. This is currently the most popular cache store for production websites. It can be used to provide a single, shared cache cluster with very high performance and redundancy.

When initializing the cache, you need to specify the addresses for all memcached servers in your cluster. If none is specified, it will assume memcached is running on the local host on the default port, but this is not an ideal set up for larger sites.

The `write` and `fetch` methods on this cache accept two additional options that take advantage of features specific to memcached. You can specify `:raw` to send a value directly to the server with no serialization. The value must be a string or number. You can use memcached direct operation like `increment` and `decrement` only on raw values. You can also specify `:unless_exist` if you don't want memcached to overwrite an existing entry.

{:lang="ruby"}
~~~
config.cache_store = :mem_cache_store, "cache-1.example.com", "cache-2.example.com"
~~~

### ActiveSupport::Cache::EhcacheStore

If you are using JRuby you can use Terracotta's Ehcache as the cache store for your application. Ehcache is an open source Java cache that also offers an enterprise version with increased scalability, management, and commercial support. You must first install the jruby-ehcache-rails3 gem (version 1.1.0 or later) to use this cache store.

{:lang="ruby"}
~~~
config.cache_store = :ehcache_store
~~~

When initializing the cache, you may use the `:ehcache_config` option to specify the Ehcache config file to use (where the default is "ehcache.xml" in your Rails config directory), and the :cache_name option to provide a custom name for your cache (the default is rails_cache).

In addition to the standard `:expires_in` option, the `write` method on this cache can also accept the additional `:unless_exist` option, which will cause the cache store to use Ehcache's `putIfAbsent` method instead of `put`, and therefore will not overwrite an existing entry. Additionally, the `write` method supports all of the properties exposed by the [Ehcache Element class](http://ehcache.org/apidocs/net/sf/ehcache/Element.html) , including:

| Property                    | Argument Type       | Description                                                 |
| --------------------------- | ------------------- | ----------------------------------------------------------- |
| elementEvictionData         | ElementEvictionData | Sets this element's eviction data instance.                 |
| eternal                     | boolean             | Sets whether the element is eternal.                        |
| timeToIdle, tti             | int                 | Sets time to idle                                           |
| timeToLive, ttl, expires_in | int                 | Sets time to Live                                           |
| version                     | long                | Sets the version attribute of the ElementAttributes object. |

These options are passed to the `write` method as Hash options using either camelCase or underscore notation, as in the following examples:

{:lang="ruby"}
~~~
Rails.cache.write('key', 'value', time_to_idle: 60.seconds, timeToLive: 600.seconds)
caches_action :index, expires_in: 60.seconds, unless_exist: true
~~~

For more information about Ehcache, see [http://ehcache.org/](http://ehcache.org/) .
For more information about Ehcache for JRuby and Rails, see [http://ehcache.org/documentation/jruby.html](http://ehcache.org/documentation/jruby.html)

### ActiveSupport::Cache::NullStore

This cache store implementation is meant to be used only in development or test environments and it never stores anything. This can be very useful in development when you have code that interacts directly with `Rails.cache`, but caching may interfere with being able to see the results of code changes. With this cache store, all `fetch` and `read` operations will result in a miss.

{:lang="ruby"}
~~~
config.cache_store = :null_store
~~~

### Custom Cache Stores

You can create your own custom cache store by simply extending `ActiveSupport::Cache::Store` and implementing the appropriate methods. In this way, you can swap in any number of caching technologies into your Rails application.

To use a custom cache store, simple set the cache store to a new instance of the class.

{:lang="ruby"}
~~~
config.cache_store = MyCacheStore.new
~~~

### Cache Keys

The keys used in a cache can be any object that responds to either `:cache_key` or to `:to_param`. You can implement the `:cache_key` method on your classes if you need to generate custom keys. Active Record will generate keys based on the class name and record id.

You can use Hashes and Arrays of values as cache keys.

{:lang="ruby"}
~~~
# This is a legal cache key
Rails.cache.read(site: "mysite", owners: [owner_1, owner_2])
~~~

The keys you use on `Rails.cache` will not be the same as those actually used with the storage engine. They may be modified with a namespace or altered to fit technology backend constraints. This means, for instance, that you can't save values with `Rails.cache` and then try to pull them out with the `memcache-client` gem. However, you also don't need to worry about exceeding the memcached size limit or violating syntax rules.

Conditional GET support
-----------------------

Conditional GETs are a feature of the HTTP specification that provide a way for web servers to tell browsers that the response to a GET request hasn't changed since the last request and can be safely pulled from the browser cache.

They work by using the `HTTP_IF_NONE_MATCH` and `HTTP_IF_MODIFIED_SINCE` headers to pass back and forth both a unique content identifier and the timestamp of when the content was last changed. If the browser makes a request where the content identifier (etag) or last modified since timestamp matches the server's version then the server only needs to send back an empty response with a not modified status.

It is the server's (i.e. our) responsibility to look for a last modified timestamp and the if-none-match header and determine whether or not to send back the full response. With conditional-get support in Rails this is a pretty easy task:

{:lang="ruby"}
~~~
class ProductsController < ApplicationController

  def show
    @product = Product.find(params[:id])

    # If the request is stale according to the given timestamp and etag value
    # (i.e. it needs to be processed again) then execute this block
    if stale?(last_modified: @product.updated_at.utc, etag: @product.cache_key)
      respond_to do |wants|
        # ... normal response processing
      end
    end

    # If the request is fresh (i.e. it's not modified) then you don't need to do
    # anything. The default render checks for this using the parameters
    # used in the previous call to stale? and will automatically send a
    # :not_modified. So that's it, you're done.
  end
end
~~~

Instead of an options hash, you can also simply pass in a model, Rails will use the `updated_at` and `cache_key` methods for setting `last_modified` and `etag`:

{:lang="ruby"}
~~~
class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    respond_with(@product) if stale?(@product)
  end
end
~~~

If you don't have any special response processing and are using the default rendering mechanism (i.e. you're not using respond_to or calling render yourself) then you've got an easy helper in fresh_when:

{:lang="ruby"}
~~~
class ProductsController < ApplicationController

  # This will automatically send back a :not_modified if the request is fresh,
  # and will render the default template (product.*) if it's stale.

  def show
    @product = Product.find(params[:id])
    fresh_when last_modified: @product.published_at.utc, etag: @product
  end
end
~~~
