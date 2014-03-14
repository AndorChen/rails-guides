---
layout: docs
title: Rails 入门
next_section: active_record_basics
---

本文介绍如何开始使用 Ruby on Rails。

读完后，你将学会：

* 如何安装 Rails，新建 Rails 程序，如何连接数据库；
* Rails 程序的基本文件结构；
* MVC（模型，视图，控制器）和 REST 架构的基本原理；
* 如何快速生成 Rails 程序骨架

---

## 前提条件 {#guide-assumptions}

本文针对想从零开始开发 Rails 程序的初学者，不需要预先具备任何的 Rails 使用经验。不过，为了能顺利阅读，还是需要事先安装好一些软件：

* [Ruby](http://www.ruby-lang.org/en/downloads)  1.9.3 及以上版本
* 包管理工具 [RubyGems](http://rubygems.org)，随 Ruby 1.9+ 安装。想深入了解 RubyGems，请阅读 [RubyGems 指南](http://guides.rubygems.org)
* [SQLite3 Database](http://www.sqlite.org)

Rails 是使用 Ruby 语言开发的网页程序框架。如果之前没接触过 Ruby，学习 Rails 可要深下一番功夫。网上有很多资源可以学习 Ruby：

* [Ruby 语言官方网站](https://www.ruby-lang.org/zh_cn/documentation/)
* [reSRC 列出的免费编程书籍](http://resrc.io/list/10/list-of-free-programming-books/#ruby)

记住，某些资源虽然很好，但一般针对 Ruby 1.8，甚至 1.6，所以没有介绍一些 Rails 日常开发会用到的句法。

## Rails 是什么？ {#what-is-rails}

Rails 是使用 Ruby 语言编写的网页程序开发框架，目的是为开发者提供常用组件，简化网页程序的开发。只需编写较少的代码，就能实现其他编程语言或框架难以企及的功能。经验丰富的 Rails 程序员会发现，Rails 让程序开发变得更有乐趣。

Rails 有自己的一套规则，认为问题总有最好的解决方法，而且建议使用最好的方法，有些情况下甚至不推荐使用其他替代方案。学会如何按照 Rails 的思维开发，能极大提高开发效率。如果坚持在 Rails 开发中使用其他语言中的旧思想，尝试使用别处学来的编程模式，开发过程就不那么有趣了。

Rails 哲学包含两大指导思想：

* **不要自我重复（DRY）：** DRY 是软件开发中的一个原则，“系统中的每个功能都要具有单一、准确、可信的实现。”。不重复表述同一件事，写出的代码才能更易维护，更具扩展性，也更不容易出问题。
* **多约定，少配置：** Rails 为网页程序的大多数需求都提供了最好的解决方法，而且默认使用这些约定，不用在长长的配置文件中设置每个细节。

## 新建 Rails 程序 {#creating-a-new-rails-project}

阅读本文时，最好跟着一步一步操作，如果错过某段代码或某个步骤，程序就可能出错，所以请一步一步跟着做。完整的源码可以在[这里](https://github.com/rails/docrails/tree/master/guides/code/getting_started)获取。

本文会新建一个名为 `blog` 的 Rails 程序，这是一个非常简单的博客。在开始开发程序之前，要确保已经安装了 Rails。

T> 文中的示例代码使用 `$` 表示命令行提示符，你的提示符可能修改过，所以可能不一样。在 Windows 中，提示符可能是 `c:\source_code>`。

### 安装 Rails {#installing-rails}

打开命令行：在 Mac OS X 中打开 Terminal.app，在 Windows 中选择“运行”，然后输入“cmd.exe”。下文中任何以 `$` 开头的代码，都要在命令行中运行。先确认是否安装了 Ruby 最新版：

T> 有很多工具可以帮助你快速在系统中安装 Ruby 和 Ruby on Rails。Windows 用户可以使用 [Rails Installer](http://railsinstaller.org)，Mac OS X 用户可以使用 [Rails One Click](http://railsoneclick.com)。

{:lang="bash"}
~~~
$ ruby -v
ruby 2.0.0p353
~~~

如果你还没安装 Ruby，请访问 [ruby-lang.org](https://www.ruby-lang.org/en/downloads/)，找到针对所用系统的安装方法。

很多类 Unix 系统都自带了版本尚新的 SQLite3。Windows 等其他操作系统的用户可以在 [SQLite3 的网站](http://www.sqlite.org)上找到安装说明。然后，确认是否在 PATH 中：

{:lang="bash"}
~~~
$ sqlite3 --version
~~~

命令行应该显示版本才对。

安装 Rails，请使用 RubyGems 提供的 `gem install` 命令：

{:lang="bash"}
~~~
$ gem install rails
~~~

要检查所有软件是否都正确安装了，可以执行下面的命令：

{:lang="bash"}
~~~
$ rails --version
~~~

如果显示的结果类似“Rails 4.1.0”，那么就可以继续往下读了。

### 创建 Blog 程序 {#creating-the-blog-application}

Rails 提供了多个被称为“生成器”的脚本，可以简化开发，生成某项操作需要的所有文件。其中一个是新程序生成器，生成一个 Rails 程序骨架，不用自己一个一个新建文件。

打开终端，进入有写权限的文件夹，执行以下命令生成一个新程序：

{:lang="bash"}
~~~
$ rails new blog
~~~

这个命令会在文件夹 `blog` 中新建一个 Rails 程序，然后执行 `bundle install` 命令安装 `Gemfile` 中列出的 gem。

T> 执行 `rails new -h` 可以查看新程序生成器的所有命令行选项。

生成 `blog` 程序后，进入该文件夹：

{:lang="bash"}
~~~
$ cd blog
~~~

`blog` 文件夹中有很多自动生成的文件和文件夹，组成一个 Rails 程序。本文大部分时间都花在 `app` 文件夹上。下面简单介绍默认生成的文件和文件夹的作用：

| 文件/文件夹 | 作用 |
| ----------- | ------- |
|app/|存放程序的控制器、模型、视图、帮助方法、邮件和静态资源文件。本文注意关注的是这个文件夹。|
|bin/|存放运行程序的 `rails` 脚本，以及其他用来部署或运行程序的脚本。|
|config/|设置程序的路由，数据库等。详情参阅[设置 Rails 程序]({{ site.baseurl }}/configuring.html)一文。|
|config.ru|基于 Rack 服务器的程序设置，用来启动程序。|
|db/|存放当前数据库的模式，以及数据库迁移文件。|
|Gemfile<br>Gemfile.lock|这些文件用来指定程序所需的 gem 依赖件，用于 Bundler gem。关于 Bundler 的详细介绍，请访问 [Bundler 官网](http://gembundler.com)。|
|lib/|程序的扩展模块。|
|log/|程序的日志文件。|
|public/|唯一对外开放的文件夹，存放静态文件和编译后的资源文件。|
|Rakefile|保存并加载可在命令行中执行的任务。任务在 Rails 的各组件中定义。如果想添加自己的任务，不要修改这个文件，把任务定义保存在 `lib/tasks` 文件夹中。|
|README.rdoc|程序的简单说明。你应该修改这个文件，告诉其他人这个程序的作用，如何安装等。|
|test/|单元测试，固件等测试用文件。详情参阅[测试 Rails 程序]({{ site.baseurl }}/testing.html)一文。|
|tmp/|临时文件，例如缓存，PID，会话文件。|
|vendor/|存放第三方代码。经常用来放第三方 gem。|

## Hello, Rails! {#hello-rails}

首先，我们来添加一些文字，在页面中显示。为了能访问网页，要启动程序服务器。

### 启动服务器 {#starting-up-the-web-server}

现在，新建的 Rails 程序是可以正常运行的。要访问网站，需要在开发电脑商启动服务器。请在 `blog` 文件夹中执行下面的命令：

{:lang="bash"}
~~~
$ rails server
~~~

T> 把 CoffeeScript 编译成 JavaScript 需要 JavaScript 运行时，如果没有运行时，会报错，提示没有 `execjs`。Mac OS X 和 Windows 一般都提供了 JavaScript 运行时。Rails 生成的 `Gemfile` 中，安装 `therubyracer` gem 的代码被注释掉了，如果需要使用这个 gem，请把前面的注释去掉。在 JRuby 中推荐使用 `therubyracer`。在 JRuby 中生成的 `Gemfile` 以及包含了这个 gem。所以支持使用的运行时参见 [ExecJS](https://github.com/sstephenson/execjs#readme)。

上述命令会启动 WEBrick，这是 Ruby 内置的服务器。要查看程序，请打开一个浏览器窗口，访问 <http://localhost:3000>。应该会看到默认的 Rails 信息页面：

![欢迎使用页面](images/getting_started/rails_welcome.png)

T> 要想停止服务器，请在命令行中按 Ctrl+C 键。服务器成功停止后回重新看到命令行提示符。在大多数类 Unix 系统中，包括 Mac OS X，命令行提示符是 `$` 符号。在开发模式中，一般情况下无需重启服务器，修改文件后，服务器会自动重新加载。

“欢迎使用”页面是新建 Rails 程序后的“冒烟测试”：确保程序设置正确，能顺利运行。你可以点击“About your application's environment”链接查看程序运行环境的信息。

### 显示“Hello, Rails!” {#say-hello-rails}

要在 Rails 中显示“Hello, Rails!”，需要新建一个控制器和试图。

控制器用来接受向程序发起的请求。路由决定哪个控制器会接受到这个请求。一般情况下，每个控制器都有多个路由，对应不同的动作。动作用来提供视图中需要的数据。

视图的作用是，以人类能看懂的格式显示数据。有一点要特别注意，数据是在控制器中获取的，而不是在视图中。视图只是把数据显示出来。默认情况下，视图使用 eRuby（嵌入式 Ruby）语言编写，经由 Rails 解析后，再发送给用户。

控制器可用控制器生成器创建，你要告诉生成器，我想要个名为“welcome”的控制器和一个名为“index”的动作，如下所示：

{:lang="bash"}
~~~
$ rails generate controller welcome index
~~~

运行上述命令后，Rails 会生成很多文件，以及一个路由。

{:lang="bash"}
~~~
create  app/controllers/welcome_controller.rb
 route  get 'welcome/index'
invoke  erb
create    app/views/welcome
create    app/views/welcome/index.html.erb
invoke  test_unit
create    test/controllers/welcome_controller_test.rb
invoke  helper
create    app/helpers/welcome_helper.rb
invoke    test_unit
create      test/helpers/welcome_helper_test.rb
invoke  assets
invoke    coffee
create      app/assets/javascripts/welcome.js.coffee
invoke    scss
create      app/assets/stylesheets/welcome.css.scss
~~~

在这些文件中，最重要的当然是控制器，位于 `app/controllers/welcome_controller.rb`，以及视图，位于 `app/views/welcome/index.html.erb`。

使用文本编辑器打开 `app/views/welcome/index.html.erb` 文件，删除全部内容，写入下面这行代码：

{:lang="html"}
~~~
<h1>Hello, Rails!</h1>
~~~

### 设置程序的首页 {#setting-the-application-home-page}

我们已经创建了控制器和视图，现在要告诉 Rails 在哪个地址显示“Hello, Rails!”。这里，我们希望访问根地址 <http://localhost:3000> 时显示。但是现在显示的还是欢迎页面。

我们要告诉 Rails 真正的首页是什么。

在编辑器中打开 `config/routes.rb` 文件。

{:lang="ruby"}
~~~
Rails.application.routes.draw do
  get 'welcome/index'

  # The priority is based upon order of creation:
  # first created -> highest priority.
  #
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  #
  # ...
~~~

这是程序的路由文件，使用特殊的 DSL（domain-specific language，领域专属语言）编写，告知 Rails 请求应该发往哪个控制器和动作。文件中有很多注释，举例说明如何定义路由。其中有一行说明了如何指定控制器和动作设置网站的根路由。找到以 `root` 开头的代码行，去掉注释，变成这样：

{:lang="ruby"}
~~~
root 'welcome#index'
~~~

`root 'welcome#index'` 告知 Rails，访问程序的根路径时，交给 `welcome` 控制器中的 `index` 动作处理。`get 'welcome/index'` 告知 Rails，访问 <http://localhost:3000/welcome/index> 时，交给 `welcome` 控制器中的 `index` 动作处理。`get 'welcome/index'` 是运行 `rails generate controller welcome index` 时生成的。

如果生成控制器时停止了服务器，请再次启动（`rails server`），然后在浏览器中访问 <http://localhost:3000>。你会看到之前写入 `app/views/welcome/index.html.erb` 文件的“Hello, Rails!”，说明新定义的路由把根目录交给 `WelcomeController` 的 `index` 动作处理了，而且也正确的渲染了视图。

T> 关于路由的详细介绍，请阅读 [Rails 路由全解]({{ site.baseurl }}/routing.html)一文。

Getting Up and Running
----------------------

Now that you've seen how to create a controller, an action and a view, let's
create something with a bit more substance.

In the Blog application, you will now create a new _resource_. A resource is the
term used for a collection of similar objects, such as articles, people or
animals.
You can create, read, update and destroy items for a resource and these
operations are referred to as _CRUD_ operations.

Rails provides a `resources` method which can be used to declare a standard REST
resource. Here's what `config/routes.rb` should look like after the
_article resource_ is declared.

{:lang="ruby"}
~~~
Blog::Application.routes.draw do

  resources :articles

  root 'welcome#index'
end
~~~

If you run `rake routes`, you'll see that it has defined routes for all the
standard RESTful actions.  The meaning of the prefix column (and other columns)
will be seen later, but for now notice that Rails has inferred the
singular form `article` and makes meaningful use of the distinction.

{:lang="bash"}
~~~
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
    articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
 new_article GET    /articles/new(.:format)      articles#new
edit_article GET    /articles/:id/edit(.:format) articles#edit
     article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy
        root GET    /                            welcome#index
~~~

In the next section, you will add the ability to create new articles in your
application and be able to view them. This is the "C" and the "R" from CRUD:
creation and reading. The form for doing this will look like this:

![The new article form](images/getting_started/new_article.png)

It will look a little basic for now, but that's ok. We'll look at improving the
styling for it afterwards.

### Laying down the ground work

Firstly, you need a place within the application to create a new article. A
great place for that would be at `/articles/new`. With the route already
defined, requests can now be made to `/articles/new` in the application.
Navigate to <http://localhost:3000/articles/new> and you'll see a routing
error:

![Another routing error, uninitialized constant ArticlesController](images/getting_started/routing_error_no_controller.png)

This error occurs because the route needs to have a controller defined in order
to serve the request. The solution to this particular problem is simple: create
a controller called `ArticlesController`. You can do this by running this
command:

{:lang="bash"}
~~~
$ rails g controller articles
~~~

If you open up the newly generated `app/controllers/articles_controller.rb`
you'll see a fairly empty controller:

{:lang="ruby"}
~~~
class ArticlesController < ApplicationController
end
~~~

A controller is simply a class that is defined to inherit from
`ApplicationController`.
It's inside this class that you'll define methods that will become the actions
for this controller. These actions will perform CRUD operations on the articles
within our system.

NOTE: There are `public`, `private` and `protected` methods in Ruby,
but only `public` methods can be actions for controllers.
For more details check out [Programming Ruby](http://www.ruby-doc.org/docs/ProgrammingRuby/).

If you refresh <http://localhost:3000/articles/new> now, you'll get a new error:

![Unknown action new for ArticlesController!](images/getting_started/unknown_action_new_for_articles.png)

This error indicates that Rails cannot find the `new` action inside the
`ArticlesController` that you just generated. This is because when controllers
are generated in Rails they are empty by default, unless you tell it
your wanted actions during the generation process.

To manually define an action inside a controller, all you need to do is to
define a new method inside the controller.
Open `app/controllers/articles_controller.rb` and inside the `ArticlesController`
class, define a `new` method like this:

{:lang="ruby"}
~~~
def new
end
~~~

With the `new` method defined in `ArticlesController`, if you refresh
<http://localhost:3000/articles/new> you'll see another error:

![Template is missing for articles/new](images/getting_started/template_is_missing_articles_new.png)

You're getting this error now because Rails expects plain actions like this one
to have views associated with them to display their information. With no view
available, Rails errors out.

In the above image, the bottom line has been truncated. Let's see what the full
thing looks like:

<blockquote>
Missing template articles/new, application/new with {locale:[:en], formats:[:html], handlers:[:erb, :builder, :coffee]}. Searched in: * "/path/to/blog/app/views"
</blockquote>

That's quite a lot of text! Let's quickly go through and understand what each
part of it does.

The first part identifies what template is missing. In this case, it's the
`articles/new` template. Rails will first look for this template. If not found,
then it will attempt to load a template called `application/new`. It looks for
one here because the `ArticlesController` inherits from `ApplicationController`.

The next part of the message contains a hash. The `:locale` key in this hash
simply indicates what spoken language template should be retrieved. By default,
this is the English - or "en" - template. The next key, `:formats` specifies the
format of template to be served in response. The default format is `:html`, and
so Rails is looking for an HTML template. The final key, `:handlers`, is telling
us what _template handlers_ could be used to render our template. `:erb` is most
commonly used for HTML templates, `:builder` is used for XML templates, and
`:coffee` uses CoffeeScript to build JavaScript templates.

The final part of this message tells us where Rails has looked for the templates.
Templates within a basic Rails application like this are kept in a single
location, but in more complex applications it could be many different paths.

The simplest template that would work in this case would be one located at
`app/views/articles/new.html.erb`. The extension of this file name is key: the
first extension is the _format_ of the template, and the second extension is the
_handler_ that will be used. Rails is attempting to find a template called
`articles/new` within `app/views` for the application. The format for this
template can only be `html` and the handler must be one of `erb`, `builder` or
`coffee`. Because you want to create a new HTML form, you will be using the `ERB`
language. Therefore the file should be called `articles/new.html.erb` and needs
to be located inside the `app/views` directory of the application.

Go ahead now and create a new file at `app/views/articles/new.html.erb` and
write this content in it:

{:lang="html"}
~~~
<h1>New Article</h1>
~~~

When you refresh <http://localhost:3000/articles/new> you'll now see that the
page has a title. The route, controller, action and view are now working
harmoniously! It's time to create the form for a new article.

### The first form

To create a form within this template, you will use a <em>form
builder</em>. The primary form builder for Rails is provided by a helper
method called `form_for`. To use this method, add this code into
`app/views/articles/new.html.erb`:

{:lang="erb"}
~~~
<%= form_for :article do |f| %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
~~~

If you refresh the page now, you'll see the exact same form as in the example.
Building forms in Rails is really just that easy!

When you call `form_for`, you pass it an identifying object for this
form. In this case, it's the symbol `:article`. This tells the `form_for`
helper what this form is for. Inside the block for this method, the
`FormBuilder` object - represented by `f` - is used to build two labels and two
text fields, one each for the title and text of an article. Finally, a call to
`submit` on the `f` object will create a submit button for the form.

There's one problem with this form though. If you inspect the HTML that is
generated, by viewing the source of the page, you will see that the `action`
attribute for the form is pointing at `/articles/new`. This is a problem because
this route goes to the very page that you're on right at the moment, and that
route should only be used to display the form for a new article.

The form needs to use a different URL in order to go somewhere else.
This can be done quite simply with the `:url` option of `form_for`.
Typically in Rails, the action that is used for new form submissions
like this is called "create", and so the form should be pointed to that action.

Edit the `form_for` line inside `app/views/articles/new.html.erb` to look like
this:

{:lang="erb"}
~~~
<%= form_for :article, url: articles_path do |f| %>
~~~

In this example, the `articles_path` helper is passed to the `:url` option.
To see what Rails will do with this, we look back at the output of
`rake routes`:

{:lang="bash"}
~~~
$ rake routes
      Prefix Verb   URI Pattern                  Controller#Action
    articles GET    /articles(.:format)          articles#index
             POST   /articles(.:format)          articles#create
 new_article GET    /articles/new(.:format)      articles#new
edit_article GET    /articles/:id/edit(.:format) articles#edit
     article GET    /articles/:id(.:format)      articles#show
             PATCH  /articles/:id(.:format)      articles#update
             PUT    /articles/:id(.:format)      articles#update
             DELETE /articles/:id(.:format)      articles#destroy
        root GET    /                            welcome#index
~~~

The `articles_path` helper tells Rails to point the form
to the URI Pattern associated with the `articles` prefix; and
the form will (by default) send a `POST` request
to that route.  This is associated with the
`create` action of the current controller, the `ArticlesController`.

With the form and its associated route defined, you will be able to fill in the
form and then click the submit button to begin the process of creating a new
article, so go ahead and do that. When you submit the form, you should see a
familiar error:

![Unknown action create for ArticlesController](images/getting_started/unknown_action_create_for_articles.png)

You now need to create the `create` action within the `ArticlesController` for
this to work.

### Creating articles

To make the "Unknown action" go away, you can define a `create` action within
the `ArticlesController` class in `app/controllers/articles_controller.rb`,
underneath the `new` action:

{:lang="ruby"}
~~~
class ArticlesController < ApplicationController
  def new
  end

  def create
  end
end
~~~

If you re-submit the form now, you'll see another familiar error: a template is
missing. That's ok, we can ignore that for now. What the `create` action should
be doing is saving our new article to the database.

When a form is submitted, the fields of the form are sent to Rails as
_parameters_. These parameters can then be referenced inside the controller
actions, typically to perform a particular task. To see what these parameters
look like, change the `create` action to this:

{:lang="ruby"}
~~~
def create
  render plain: params[:article].inspect
end
~~~

The `render` method here is taking a very simple hash with a key of `text` and
value of `params[:article].inspect`. The `params` method is the object which
represents the parameters (or fields) coming in from the form. The `params`
method returns an `ActiveSupport::HashWithIndifferentAccess` object, which
allows you to access the keys of the hash using either strings or symbols. In
this situation, the only parameters that matter are the ones from the form.

If you re-submit the form one more time you'll now no longer get the missing
template error. Instead, you'll see something that looks like the following:

{:lang="ruby"}
~~~
{"title"=>"First article!", "text"=>"This is my first article."}
~~~

This action is now displaying the parameters for the article that are coming in
from the form. However, this isn't really all that helpful. Yes, you can see the
parameters but nothing in particular is being done with them.

### Creating the Article model

Models in Rails use a singular name, and their corresponding database tables use
a plural name. Rails provides a generator for creating models, which
most Rails developers tend to use when creating new models.
To create the new model, run this command in your terminal:

{:lang="bash"}
~~~
$ rails generate model Article title:string text:text
~~~

With that command we told Rails that we want a `Article` model, together
with a _title_ attribute of type string, and a _text_ attribute
of type text. Those attributes are automatically added to the `articles`
table in the database and mapped to the `Article` model.

Rails responded by creating a bunch of files. For
now, we're only interested in `app/models/article.rb` and
`db/migrate/20140120191729_create_articles.rb` (your name could be a bit
different). The latter is responsible
for creating the database structure, which is what we'll look at next.

TIP: Active Record is smart enough to automatically map column names to
model attributes, which means you don't have to declare attributes
inside Rails models, as that will be done automatically by Active
Record.

### Running a Migration

As we've just seen, `rails generate model` created a _database
migration_ file inside the `db/migrate` directory.
Migrations are Ruby classes that are designed to make it simple to
create and modify database tables. Rails uses rake commands to run migrations,
and it's possible to undo a migration after it's been applied to your database.
Migration filenames include a timestamp to ensure that they're processed in the
order that they were created.

If you look in the `db/migrate/20140120191729_create_articles.rb` file (remember,
yours will have a slightly different name), here's what you'll find:

{:lang="ruby"}
~~~
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
~~~

The above migration creates a method named `change` which will be called when
you run this migration. The action defined in this method is also reversible,
which means Rails knows how to reverse the change made by this migration,
in case you want to reverse it later. When you run this migration it will create
an `articles` table with one string column and a text column. It also creates
two timestamp fields to allow Rails to track article creation and update times.

TIP: For more information about migrations, refer to [Rails Database
Migrations](migrations.html).

At this point, you can use a rake command to run the migration:

{:lang="bash"}
~~~
$ rake db:migrate
~~~

Rails will execute this migration command and tell you it created the Articles
table.

{:lang="bash"}
~~~
==  CreateArticles: migrating ==================================================
-- create_table(:articles)
   -> 0.0019s
==  CreateArticles: migrated (0.0020s) =========================================
~~~

NOTE. Because you're working in the development environment by default, this
command will apply to the database defined in the `development` section of your
`config/database.yml` file. If you would like to execute migrations in another
environment, for instance in production, you must explicitly pass it when
invoking the command: `rake db:migrate RAILS_ENV=production`.

### Saving data in the controller

Back in `ArticlesController`, we need to change the `create` action
to use the new `Article` model to save the data in the database.
Open `app/controllers/articles_controller.rb` and change the `create` action to
look like this:

{:lang="ruby"}
~~~
def create
  @article = Article.new(params[:article])

  @article.save
  redirect_to @article
end
~~~

Here's what's going on: every Rails model can be initialized with its
respective attributes, which are automatically mapped to the respective
database columns. In the first line we do just that
(remember that `params[:article]` contains the attributes we're interested in).
Then, `@article.save` is responsible for saving the model in the database.
Finally, we redirect the user to the `show` action, which we'll define later.

TIP: As we'll see later, `@article.save` returns a boolean indicating
whether the article was saved or not.

If you now go to
<http://localhost:3000/articles/new> you'll *almost* be able to create an
article. Try it! You should get an error that looks like this:

![Forbidden attributes for new article](images/getting_started/forbidden_attributes_for_new_article.png)

Rails has several security features that help you write secure applications,
and you're running into one of them now. This one is called
`strong_parameters`, which requires us to tell Rails exactly which parameters
we want to accept in our controllers. In this case, we want to allow the
`title` and `text` parameters, so change your `create` controller action to
look like this:

{:lang="ruby"}
~~~
def create
  @article = Article.new(article_params)

  @article.save
  redirect_to @article
end

private
  def article_params
    params.require(:article).permit(:title, :text)
  end
~~~

See the `permit`? It allows us to accept both `title` and `text` in this
action.

TIP: Note that `def article_params` is private. This new approach prevents an
attacker from setting the model's attributes by manipulating the hash passed to
the model.
For more information, refer to
[this blog article about Strong Parameters](http://weblog.rubyonrails.org/2012/3/21/strong-parameters/).

### Showing Articles

If you submit the form again now, Rails will complain about not finding
the `show` action. That's not very useful though, so let's add the
`show` action before proceeding.

As we have seen in the output of `rake routes`, the route for `show` action is
as follows:

~~~
article GET    /articles/:id(.:format)      articles#show
~~~

The special syntax `:id` tells rails that this route expects an `:id`
parameter, which in our case will be the id of the article.

As we did before, we need to add the `show` action in
`app/controllers/articles_controller.rb` and its respective view.

{:lang="ruby"}
~~~
def show
  @article = Article.find(params[:id])
end
~~~

A couple of things to note. We use `Article.find` to find the article we're
interested in, passing in `params[:id]` to get the `:id` parameter from the
request. We also use an instance variable (prefixed by `@`) to hold a
reference to the article object. We do this because Rails will pass all instance
variables to the view.

Now, create a new file `app/views/articles/show.html.erb` with the following
content:

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>
~~~

With this change, you should finally be able to create new articles.
Visit <http://localhost:3000/articles/new> and give it a try!

![Show action for articles](images/getting_started/show_action_for_articles.png)

### Listing all articles

We still need a way to list all our articles, so let's do that.
The route for this as per output of `rake routes` is:

~~~
articles GET    /articles(.:format)          articles#index
~~~

Add the corresponding `index` action for that route inside the
`ArticlesController` in the `app/controllers/articles_controller.rb` file:

{:lang="ruby"}
~~~
def index
  @articles = Article.all
end
~~~

And then finally, add view for this action, located at
`app/views/articles/index.html.erb`:

{:lang="erb"}
~~~
<h1>Listing articles</h1>

<table>
  <tr>
    <th>Title</th>
    <th>Text</th>
  </tr>

  <% @articles.each do |article| %>
    <tr>
      <td><%= article.title %></td>
      <td><%= article.text %></td>
    </tr>
  <% end %>
</table>
~~~

Now if you go to `http://localhost:3000/articles` you will see a list of all the
articles that you have created.

### Adding links

You can now create, show, and list articles. Now let's add some links to
navigate through pages.

Open `app/views/welcome/index.html.erb` and modify it as follows:

{:lang="erb"}
~~~
<h1>Hello, Rails!</h1>
<%= link_to 'My Blog', controller: 'articles' %>
~~~

The `link_to` method is one of Rails' built-in view helpers. It creates a
hyperlink based on text to display and where to go - in this case, to the path
for articles.

Let's add links to the other views as well, starting with adding this
"New Article" link to `app/views/articles/index.html.erb`, placing it above the
`<table>` tag:

{:lang="erb"}
~~~
<%= link_to 'New article', new_article_path %>
~~~

This link will allow you to bring up the form that lets you create a new article.

Also add a link in `app/views/articles/new.html.erb`, underneath the form, to
go back to the `index` action:

{:lang="erb"}
~~~
<%= form_for :article do |f| %>
  ...
<% end %>

<%= link_to 'Back', articles_path %>
~~~

Finally, add another link to the `app/views/articles/show.html.erb` template to
go back to the `index` action as well, so that people who are viewing a single
article can go back and view the whole list again:

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<%= link_to 'Back', articles_path %>
~~~

TIP: If you want to link to an action in the same controller, you don't
need to specify the `:controller` option, as Rails will use the current
controller by default.

TIP: In development mode (which is what you're working in by default), Rails
reloads your application with every browser request, so there's no need to stop
and restart the web server when a change is made.

### Adding Some Validation

The model file, `app/models/article.rb` is about as simple as it can get:

{:lang="ruby"}
~~~
class Article < ActiveRecord::Base
end
~~~

There isn't much to this file - but note that the `Article` class inherits from
`ActiveRecord::Base`. Active Record supplies a great deal of functionality to
your Rails models for free, including basic database CRUD (Create, Read, Update,
Destroy) operations, data validation, as well as sophisticated search support
and the ability to relate multiple models to one another.

Rails includes methods to help you validate the data that you send to models.
Open the `app/models/article.rb` file and edit it:

{:lang="ruby"}
~~~
class Article < ActiveRecord::Base
  validates :title, presence: true,
                    length: { minimum: 5 }
end
~~~

These changes will ensure that all articles have a title that is at least five
characters long. Rails can validate a variety of conditions in a model,
including the presence or uniqueness of columns, their format, and the
existence of associated objects. Validations are covered in detail in [Active
Record Validations](active_record_validations.html)

With the validation now in place, when you call `@article.save` on an invalid
article, it will return `false`. If you open
`app/controllers/articles_controller.rb` again, you'll notice that we don't
check the result of calling `@article.save` inside the `create` action.
If `@article.save` fails in this situation, we need to show the form back to the
user. To do this, change the `new` and `create` actions inside
`app/controllers/articles_controller.rb` to these:

{:lang="ruby"}
~~~
def new
  @article = Article.new
end

def create
  @article = Article.new(article_params)

  if @article.save
    redirect_to @article
  else
    render 'new'
  end
end

private
  def article_params
    params.require(:article).permit(:title, :text)
  end
~~~

The `new` action is now creating a new instance variable called `@article`, and
you'll see why that is in just a few moments.

Notice that inside the `create` action we use `render` instead of `redirect_to`
when `save` returns `false`. The `render` method is used so that the `@article`
object is passed back to the `new` template when it is rendered. This rendering
is done within the same request as the form submission, whereas the
`redirect_to` will tell the browser to issue another request.

If you reload
<http://localhost:3000/articles/new> and
try to save an article without a title, Rails will send you back to the
form, but that's not very useful. You need to tell the user that
something went wrong. To do that, you'll modify
`app/views/articles/new.html.erb` to check for error messages:

{:lang="erb"}
~~~
<%= form_for :article, url: articles_path do |f| %>
  <% if @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited
      this article from being saved:</h2>
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>

<%= link_to 'Back', articles_path %>
~~~

A few things are going on. We check if there are any errors with
`@article.errors.any?`, and in that case we show a list of all
errors with `@article.errors.full_messages`.

`pluralize` is a rails helper that takes a number and a string as its
arguments. If the number is greater than one, the string will be automatically
pluralized.

The reason why we added `@article = Article.new` in the `ArticlesController` is
that otherwise `@article` would be `nil` in our view, and calling
`@article.errors.any?` would throw an error.

TIP: Rails automatically wraps fields that contain an error with a div
with class `field_with_errors`. You can define a css rule to make them
standout.

Now you'll get a nice error message when saving an article without title when
you attempt to do just that on the new article form
[(http://localhost:3000/articles/new)](http://localhost:3000/articles/new).

![Form With Errors](images/getting_started/form_with_errors.png)

### Updating Articles

We've covered the "CR" part of CRUD. Now let's focus on the "U" part, updating
articles.

The first step we'll take is adding an `edit` action to the `ArticlesController`.

{:lang="ruby"}
~~~
def edit
  @article = Article.find(params[:id])
end
~~~

The view will contain a form similar to the one we used when creating
new articles. Create a file called `app/views/articles/edit.html.erb` and make
it look as follows:

{:lang="erb"}
~~~
<h1>Editing article</h1>

<%= form_for :article, url: article_path(@article), method: :patch do |f| %>
  <% if @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited
      this article from being saved:</h2>
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>

<%= link_to 'Back', articles_path %>
~~~

This time we point the form to the `update` action, which is not defined yet
but will be very soon.

The `method: :patch` option tells Rails that we want this form to be submitted
via the `PATCH` HTTP method which is the HTTP method you're expected to use to
**update** resources according to the REST protocol.

The first parameter of the `form_tag` can be an object, say, `@article` which would
cause the helper to fill in the form with the fields of the object. Passing in a
symbol (`:article`) with the same name as the instance variable (`@article`) also
automagically leads to the same behavior. This is what is happening here. More details
can be found in [form_for documentation](http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for).

Next we need to create the `update` action in
`app/controllers/articles_controller.rb`:

{:lang="ruby"}
~~~
def update
  @article = Article.find(params[:id])

  if @article.update(article_params)
    redirect_to @article
  else
    render 'edit'
  end
end

private
  def article_params
    params.require(:article).permit(:title, :text)
  end
~~~

The new method, `update`, is used when you want to update a record
that already exists, and it accepts a hash containing the attributes
that you want to update. As before, if there was an error updating the
article we want to show the form back to the user.

We reuse the `article_params` method that we defined earlier for the create
action.

TIP: You don't need to pass all attributes to `update`. For
example, if you'd call `@article.update(title: 'A new title')`
Rails would only update the `title` attribute, leaving all other
attributes untouched.

Finally, we want to show a link to the `edit` action in the list of all the
articles, so let's add that now to `app/views/articles/index.html.erb` to make
it appear next to the "Show" link:

{:lang="erb"}
~~~
<table>
  <tr>
    <th>Title</th>
    <th>Text</th>
    <th colspan="2"></th>
  </tr>

<% @articles.each do |article| %>
  <tr>
    <td><%= article.title %></td>
    <td><%= article.text %></td>
    <td><%= link_to 'Show', article_path(article) %></td>
    <td><%= link_to 'Edit', edit_article_path(article) %></td>
  </tr>
<% end %>
</table>
~~~

And we'll also add one to the `app/views/articles/show.html.erb` template as
well, so that there's also an "Edit" link on an article's page. Add this at the
bottom of the template:

{:lang="erb"}
~~~
...

<%= link_to 'Back', articles_path %>
| <%= link_to 'Edit', edit_article_path(@article) %>
~~~

And here's how our app looks so far:

![Index action with edit link](images/getting_started/index_action_with_edit_link.png)

### Using partials to clean up duplication in views

Our `edit` page looks very similar to the `new` page, in fact they
both share the same code for displaying the form. Let's remove some duplication
by using a view partial. By convention, partial files are prefixed by an
underscore.

TIP: You can read more about partials in the
[Layouts and Rendering in Rails](layouts_and_rendering.html) guide.

Create a new file `app/views/articles/_form.html.erb` with the following
content:

{:lang="erb"}
~~~
<%= form_for @article do |f| %>
  <% if @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited
      this article from being saved:</h2>
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
~~~

Everything except for the `form_for` declaration remained the same.
The reason we can use this shorter, simpler `form_for` declaration
to stand in for either of the other forms is that `@article` is a *resource*
corresponding to a full set of RESTful routes, and Rails is able to infer
which URI and method to use.
For more information about this use of `form_for`, see
[Resource-oriented style](//api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-form_for-label-Resource-oriented+style).

Now, let's update the `app/views/articles/new.html.erb` view to use this new
partial, rewriting it completely:

{:lang="erb"}
~~~
<h1>New article</h1>

<%= render 'form' %>

<%= link_to 'Back', articles_path %>
~~~

Then do the same for the `app/views/articles/edit.html.erb` view:

{:lang="erb"}
~~~
<h1>Edit article</h1>

<%= render 'form' %>

<%= link_to 'Back', articles_path %>
~~~

### Deleting Articles

We're now ready to cover the "D" part of CRUD, deleting articles from the
database. Following the REST convention, the route for
deleting articles as per output of `rake routes` is:

{:lang="ruby"}
~~~
DELETE /articles/:id(.:format)      articles#destroy
~~~

The `delete` routing method should be used for routes that destroy
resources. If this was left as a typical `get` route, it could be possible for
people to craft malicious URLs like this:

{:lang="html"}
~~~
<a href='http://example.com/articles/1/destroy'>look at this cat!</a>
~~~

We use the `delete` method for destroying resources, and this route is mapped to
the `destroy` action inside `app/controllers/articles_controller.rb`, which
doesn't exist yet, but is provided below:

{:lang="ruby"}
~~~
def destroy
  @article = Article.find(params[:id])
  @article.destroy

  redirect_to articles_path
end
~~~

You can call `destroy` on Active Record objects when you want to delete
them from the database. Note that we don't need to add a view for this
action since we're redirecting to the `index` action.

Finally, add a 'Destroy' link to your `index` action template
(`app/views/articles/index.html.erb`) to wrap everything
together.

{:lang="erb"}
~~~
<h1>Listing Articles</h1>
<%= link_to 'New article', new_article_path %>
<table>
  <tr>
    <th>Title</th>
    <th>Text</th>
    <th colspan="3"></th>
  </tr>

<% @articles.each do |article| %>
  <tr>
    <td><%= article.title %></td>
    <td><%= article.text %></td>
    <td><%= link_to 'Show', article_path(article) %></td>
    <td><%= link_to 'Edit', edit_article_path(article) %></td>
    <td><%= link_to 'Destroy', article_path(article),
                    method: :delete, data: { confirm: 'Are you sure?' } %></td>
  </tr>
<% end %>
</table>
~~~

Here we're using `link_to` in a different way. We pass the named route as the
second argument, and then the options as another argument. The `:method` and
`:'data-confirm'` options are used as HTML5 attributes so that when the link is
clicked, Rails will first show a confirm dialog to the user, and then submit the
link with method `delete`.  This is done via the JavaScript file `jquery_ujs`
which is automatically included into your application's layout
(`app/views/layouts/application.html.erb`) when you generated the application.
Without this file, the confirmation dialog box wouldn't appear.

![Confirm Dialog](images/getting_started/confirm_dialog.png)

Congratulations, you can now create, show, list, update and destroy
articles.

TIP: In general, Rails encourages the use of resources objects in place
of declaring routes manually.
For more information about routing, see
[Rails Routing from the Outside In](routing.html).

Adding a Second Model
---------------------

It's time to add a second model to the application. The second model will handle
comments on articles.

### Generating a Model

We're going to see the same generator that we used before when creating
the `Article` model. This time we'll create a `Comment` model to hold
reference of article comments. Run this command in your terminal:

{:lang="bash"}
~~~
$ rails generate model Comment commenter:string body:text article:references
~~~

This command will generate four files:

| File                                         | Purpose                                                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| db/migrate/20140120201010_create_comments.rb | Migration to create the comments table in your database (your name will include a different timestamp) |
| app/models/comment.rb                        | The Comment model                                                                                      |
| test/models/comment_test.rb                  | Testing harness for the comments model                                                                 |
| test/fixtures/comments.yml                   | Sample comments for use in testing                                                                     |

First, take a look at `app/models/comment.rb`:

{:lang="ruby"}
~~~
class Comment < ActiveRecord::Base
  belongs_to :article
end
~~~

This is very similar to the `Article` model that you saw earlier. The difference
is the line `belongs_to :article`, which sets up an Active Record _association_.
You'll learn a little about associations in the next section of this guide.

In addition to the model, Rails has also made a migration to create the
corresponding database table:

{:lang="ruby"}
~~~
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body

      # this line adds an integer column called `article_id`.
      t.references :article, index: true

      t.timestamps
    end
  end
end
~~~

The `t.references` line sets up a foreign key column for the association between
the two models. An index for this association is also created on this column.
Go ahead and run the migration:

{:lang="bash"}
~~~
$ rake db:migrate
~~~

Rails is smart enough to only execute the migrations that have not already been
run against the current database, so in this case you will just see:

{:lang="bash"}
~~~
==  CreateComments: migrating =================================================
-- create_table(:comments)
   -> 0.0115s
==  CreateComments: migrated (0.0119s) ========================================
~~~

### Associating Models

Active Record associations let you easily declare the relationship between two
models. In the case of comments and articles, you could write out the
relationships this way:

* Each comment belongs to one article.
* One article can have many comments.

In fact, this is very close to the syntax that Rails uses to declare this
association. You've already seen the line of code inside the `Comment` model
(app/models/comment.rb) that makes each comment belong to an Article:

{:lang="ruby"}
~~~
class Comment < ActiveRecord::Base
  belongs_to :article
end
~~~

You'll need to edit `app/models/article.rb` to add the other side of the
association:

{:lang="ruby"}
~~~
class Article < ActiveRecord::Base
  has_many :comments
  validates :title, presence: true,
                    length: { minimum: 5 }
end
~~~

These two declarations enable a good bit of automatic behavior. For example, if
you have an instance variable `@article` containing an article, you can retrieve
all the comments belonging to that article as an array using
`@article.comments`.

TIP: For more information on Active Record associations, see the [Active Record
Associations](association_basics.html) guide.

### Adding a Route for Comments

As with the `welcome` controller, we will need to add a route so that Rails
knows where we would like to navigate to see `comments`. Open up the
`config/routes.rb` file again, and edit it as follows:

{:lang="ruby"}
~~~
resources :articles do
  resources :comments
end
~~~

This creates `comments` as a _nested resource_ within `articles`. This is
another part of capturing the hierarchical relationship that exists between
articles and comments.

TIP: For more information on routing, see the [Rails Routing](routing.html)
guide.

### Generating a Controller

With the model in hand, you can turn your attention to creating a matching
controller. Again, we'll use the same generator we used before:

{:lang="bash"}
~~~
$ rails generate controller Comments
~~~

This creates six files and one empty directory:

| File/Directory                               | Purpose                                  |
| -------------------------------------------- | ---------------------------------------- |
| app/controllers/comments_controller.rb       | The Comments controller                  |
| app/views/comments/                          | Views of the controller are stored here  |
| test/controllers/comments_controller_test.rb | The test for the controller              |
| app/helpers/comments_helper.rb               | A view helper file                       |
| test/helpers/comments_helper_test.rb         | The test for the helper                  |
| app/assets/javascripts/comment.js.coffee     | CoffeeScript for the controller          |
| app/assets/stylesheets/comment.css.scss      | Cascading style sheet for the controller |

Like with any blog, our readers will create their comments directly after
reading the article, and once they have added their comment, will be sent back
to the article show page to see their comment now listed. Due to this, our
`CommentsController` is there to provide a method to create comments and delete
spam comments when they arrive.

So first, we'll wire up the Article show template
(`app/views/articles/show.html.erb`) to let us make a new comment:

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<h2>Add a comment:</h2>
<%= form_for([@article, @article.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br>
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>

<%= link_to 'Back', articles_path %>
| <%= link_to 'Edit', edit_article_path(@article) %>
~~~

This adds a form on the `Article` show page that creates a new comment by
calling the `CommentsController` `create` action. The `form_for` call here uses
an array, which will build a nested route, such as `/articles/1/comments`.

Let's wire up the `create` in `app/controllers/comments_controller.rb`:

{:lang="ruby"}
~~~
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
~~~

You'll see a bit more complexity here than you did in the controller for
articles. That's a side-effect of the nesting that you've set up. Each request
for a comment has to keep track of the article to which the comment is attached,
thus the initial call to the `find` method of the `Article` model to get the
article in question.

In addition, the code takes advantage of some of the methods available for an
association. We use the `create` method on `@article.comments` to create and
save the comment. This will automatically link the comment so that it belongs to
that particular article.

Once we have made the new comment, we send the user back to the original article
using the `article_path(@article)` helper. As we have already seen, this calls
the `show` action of the `ArticlesController` which in turn renders the
`show.html.erb` template. This is where we want the comment to show, so let's
add that to the `app/views/articles/show.html.erb`.

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<h2>Comments</h2>
<% @article.comments.each do |comment| %>
  <p>
    <strong>Commenter:</strong>
    <%= comment.commenter %>
  </p>

  <p>
    <strong>Comment:</strong>
    <%= comment.body %>
  </p>
<% end %>

<h2>Add a comment:</h2>
<%= form_for([@article, @article.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br>
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>

<%= link_to 'Edit Article', edit_article_path(@article) %> |
<%= link_to 'Back to Articles', articles_path %>
~~~

Now you can add articles and comments to your blog and have them show up in the
right places.

![Article with Comments](images/getting_started/article_with_comments.png)

Refactoring
-----------

Now that we have articles and comments working, take a look at the
`app/views/articles/show.html.erb` template. It is getting long and awkward. We
can use partials to clean it up.

### Rendering Partial Collections

First, we will make a comment partial to extract showing all the comments for
the article. Create the file `app/views/comments/_comment.html.erb` and put the
following into it:

{:lang="erb"}
~~~
<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>
~~~

Then you can change `app/views/articles/show.html.erb` to look like the
following:

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<h2>Comments</h2>
<%= render @article.comments %>

<h2>Add a comment:</h2>
<%= form_for([@article, @article.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br>
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>

<%= link_to 'Edit Article', edit_article_path(@article) %> |
<%= link_to 'Back to Articles', articles_path %>
~~~

This will now render the partial in `app/views/comments/_comment.html.erb` once
for each comment that is in the `@article.comments` collection. As the `render`
method iterates over the `@article.comments` collection, it assigns each
comment to a local variable named the same as the partial, in this case
`comment` which is then available in the partial for us to show.

### Rendering a Partial Form

Let us also move that new comment section out to its own partial. Again, you
create a file `app/views/comments/_form.html.erb` containing:

{:lang="erb"}
~~~
<%= form_for([@article, @article.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br>
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>
~~~

Then you make the `app/views/articles/show.html.erb` look like the following:

{:lang="erb"}
~~~
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<h2>Comments</h2>
<%= render @article.comments %>

<h2>Add a comment:</h2>
<%= render "comments/form" %>

<%= link_to 'Edit Article', edit_article_path(@article) %> |
<%= link_to 'Back to Articles', articles_path %>
~~~

The second render just defines the partial template we want to render,
`comments/form`. Rails is smart enough to spot the forward slash in that
string and realize that you want to render the `_form.html.erb` file in
the `app/views/comments` directory.

The `@article` object is available to any partials rendered in the view because
we defined it as an instance variable.

Deleting Comments
-----------------

Another important feature of a blog is being able to delete spam comments. To do
this, we need to implement a link of some sort in the view and a `destroy`
action in the `CommentsController`.

So first, let's add the delete link in the
`app/views/comments/_comment.html.erb` partial:

{:lang="erb"}
~~~
<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>

<p>
  <%= link_to 'Destroy Comment', [comment.article, comment],
               method: :delete,
               data: { confirm: 'Are you sure?' } %>
</p>
~~~

Clicking this new "Destroy Comment" link will fire off a `DELETE
/articles/:article_id/comments/:id` to our `CommentsController`, which can then
use this to find the comment we want to delete, so let's add a `destroy` action
to our controller (`app/controllers/comments_controller.rb`):

{:lang="ruby"}
~~~
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
~~~

The `destroy` action will find the article we are looking at, locate the comment
within the `@article.comments` collection, and then remove it from the
database and send us back to the show action for the article.


### Deleting Associated Objects

If you delete an article then its associated comments will also need to be
deleted. Otherwise they would simply occupy space in the database. Rails allows
you to use the `dependent` option of an association to achieve this. Modify the
Article model, `app/models/article.rb`, as follows:

{:lang="ruby"}
~~~
class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
end
~~~

Security
--------

### Basic Authentication

If you were to publish your blog online, anybody would be able to add, edit and
delete articles or delete comments.

Rails provides a very simple HTTP authentication system that will work nicely in
this situation.

In the `ArticlesController` we need to have a way to block access to the various
actions if the person is not authenticated, here we can use the Rails
`http_basic_authenticate_with` method, allowing access to the requested
action if that method allows it.

To use the authentication system, we specify it at the top of our
`ArticlesController`, in this case, we want the user to be authenticated on
every action, except for `index` and `show`, so we write that in
`app/controllers/articles_controller.rb`:

{:lang="ruby"}
~~~
class ArticlesController < ApplicationController

  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  def index
    @articles = Article.all
  end

  # snipped for brevity
~~~

We also want to allow only authenticated users to delete comments, so in the
`CommentsController` (`app/controllers/comments_controller.rb`) we write:

{:lang="ruby"}
~~~
class CommentsController < ApplicationController

  http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

  def create
    @article = Article.find(params[:article_id])
    ...
  end

  # snipped for brevity
~~~

Now if you try to create a new article, you will be greeted with a basic HTTP
Authentication challenge

![Basic HTTP Authentication Challenge](images/getting_started/challenge.png)

Other authentication methods are available for Rails applications. Two popular
authentication add-ons for Rails are the
[Devise](https://github.com/plataformatec/devise) rails engine and
the [Authlogic](https://github.com/binarylogic/authlogic) gem,
along with a number of others.


### Other Security Considerations

Security, especially in web applications, is a broad and detailed area. Security
in your Rails application is covered in more depth in
The [Ruby on Rails Security Guide](security.html)


What's Next?
------------

Now that you've seen your first Rails application, you should feel free to
update it and experiment on your own. But you don't have to do everything
without help. As you need assistance getting up and running with Rails, feel
free to consult these support resources:

* The [Ruby on Rails guides](index.html)
* The [Ruby on Rails Tutorial](http://railstutorial.org/book)
* The [Ruby on Rails mailing list](http://groups.google.com/group/rubyonrails-talk)
* The [#rubyonrails](irc://irc.freenode.net/#rubyonrails) channel on irc.freenode.net

Rails also comes with built-in help that you can generate using the rake
command-line utility:

* Running `rake doc:guides` will put a full copy of the Rails Guides in the
  `doc/guides` folder of your application. Open `doc/guides/index.html` in your
  web browser to explore the Guides.
* Running `rake doc:rails` will put a full copy of the API documentation for
  Rails in the `doc/api` folder of your application. Open `doc/api/index.html`
  in your web browser to explore the API documentation.

TIP: To be able to generate the Rails Guides locally with the `doc:guides` rake
task you need to install the RedCloth gem. Add it to your `Gemfile` and run
`bundle install` and you're ready to go.

Configuration Gotchas
---------------------

The easiest way to work with Rails is to store all external data as UTF-8. If
you don't, Ruby libraries and Rails will often be able to convert your native
data into UTF-8, but this doesn't always work reliably, so you're better off
ensuring that all external data is UTF-8.

If you have made a mistake in this area, the most common symptom is a black
diamond with a question mark inside appearing in the browser. Another common
symptom is characters like "Ã¼" appearing instead of "ü". Rails takes a number
of internal steps to mitigate common causes of these problems that can be
automatically detected and corrected. However, if you have external data that is
not stored as UTF-8, it can occasionally result in these kinds of issues that
cannot be automatically detected by Rails and corrected.

Two very common sources of data that are not UTF-8:

* Your text editor: Most text editors (such as TextMate), default to saving
  files as UTF-8. If your text editor does not, this can result in special
  characters that you enter in your templates (such as é) to appear as a diamond
  with a question mark inside in the browser. This also applies to your i18n
  translation files. Most editors that do not already default to UTF-8 (such as
  some versions of Dreamweaver) offer a way to change the default to UTF-8. Do
  so.
* Your database: Rails defaults to converting data from your database into UTF-8
  at the boundary. However, if your database is not using UTF-8 internally, it
  may not be able to store all characters that your users enter. For instance,
  if your database is using Latin-1 internally, and your user enters a Russian,
  Hebrew, or Japanese character, the data will be lost forever once it enters
  the database. If possible, use UTF-8 as the internal storage of your database.
