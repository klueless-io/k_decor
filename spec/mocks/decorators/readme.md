# Decorator Overview

## Mock Samples

Here is a list of the mock decorators and what they demonstrate.

Every model and decorator is a contrived example for testing only, they are not included in the GEM production code.

### Model Decorator

The base model decorator ensures that any descendent from it is compatible with any type of Model class.

It will affect the model by updating the touched flag if it is called.

Why would it not be called?

A child class may decide not to call super for update.

see: Anti Pattern section about why this sample is included.

### Todo Model Decorator

An incomplete example of a decorator used to test the implementation of the update method.

### Pluralize Model Decorator

Simple example of updating an attribute based on the value of another attribute.

```ruby
model = new ModelPerson()

# before

puts model.model            # Person
puts model.model_plural     # nil

# after
PluralizeModelDecorator.new.decorate(model)

puts model.model            # Person
puts model.model_plural     # People
```

### Alter Names Model Decorator

Simple example t (FILL IN LATER, )
```ruby
john  = new ModelPerson(first_name: 'John', last_name: 'Doe')
david = new ModelPerson(first_name: 'David', last_name: 'Cruwys')

# after
AlterNamesModelDecorator.new.decorate(john)

puts john.first_name          # John
puts john.last_name           # Doe

AlterNamesModelDecorator.new.decorate(david) = new ModelPerson(first_name: 'David', last_name: 'Cruwys')

puts david.first_name          # Dave
puts david.last_name           # was here

```

### Add First/Last Name Model Decorator

Update the structure of the model by attaching new attributes (:first_name, :last_read)

```ruby
model = new ModelAccount()

# before
model.respond_to?(:first_name)    # false
model.respond_to?(:last_name)     # false

# after
model.respond_to?(:first_name)    # true
model.respond_to?(:last_name)     # true
```

### Add Full Name Model Decorator

Update the structure of the model by attaching new attribute :full_name if not found; and 
then build full_name from first_name and last_name.

```ruby
model = new ModelPerson(first_name: 'John', last_name: 'Doe')

# before
model.respond_to?(:first_name)    # true
model.respond_to?(:last_name)     # true
model.respond_to?(:full_name)     # false

# after
model.respond_to?(:first_name)    # true
model.respond_to?(:last_name)     # true
model.respond_to?(:full_name)     # true

puts model.full_name              # John Doe
```


### Model Todo Decorator

ModelAddFullNameDecorator

## Additional information

### Why not use SimpleDelegator

Originally I was wrapping the data objects in SimpleDelegator which means that you can access all the private data directly, this creates tight coupling with the decorator knowing and having access to internal data on another object.

I am opting for loose coupling with this project and so if you need access to internal data like this, then you can do one of the following.

1. Add an interface (aka public methods) to your model so the delegator can manipulate the internal data.
2. Wrap your model in SimpleDelegator and expose an interface methods for altering the internal data and pass the wrapped model instead of the original model
3. Use meta programming `model.send(:internal_data)`


### Some anti-patterns

The decorators here listed here are samples only.

Unfortunately as samples they do exhibit a couple of anti-patterns.

`ModelPluralizeDecorator`

This decorator calls `super.update` on `ModelDecorator`
  
  - This is helpful as an example of what can be done, but;
  - It creates unwarranted complexity and coupling that would be better served with composition in the overall example of model decorators.
  - Meaning: would better to have a new decorator called TouchedModelDecorator

