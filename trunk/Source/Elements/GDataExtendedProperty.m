/* Copyright (c) 2007 Google Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

//
//  GDataExtendedProperty.m
//

#import "GDataExtendedProperty.h"

@implementation GDataExtendedProperty
// an element with a name="" and a value="" attribute, as in
//  <gd:extendedProperty name='X-MOZ-ALARM-LAST-ACK' value='2006-10-03T19:01:14Z'/>
//
// or an arbitrary XML blob, as in 
//  <gd:extendedProperty name='com.myCompany.myProperties'> <myXMLBlob /> </gd:extendedProperty>
//
// Servers may impose additional restrictions on names or on the size
// or composition of the values.

+ (NSString *)extensionElementURI       { return kGDataNamespaceGData; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceGDataPrefix; }
+ (NSString *)extensionElementLocalName { return @"extendedProperty"; }

+ (id)propertyWithName:(NSString *)name
                 value:(NSString *)value {

  GDataExtendedProperty* obj = [[[GDataExtendedProperty alloc] init] autorelease];
  [obj setName:name];
  [obj setValue:value];
  return obj;
}

- (id)initWithXMLElement:(NSXMLElement *)element
                  parent:(GDataObject *)parent {
  self = [super initWithXMLElement:element
                            parent:parent];
  if (self) {
    [self setValue:[self stringForAttributeName:@"value"
                                    fromElement:element]];
    [self setName:[self stringForAttributeName:@"name"
                                   fromElement:element]];
  }
  return self;
}

- (void)dealloc {
  [value_ release];
  [name_ release];
  [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
  GDataExtendedProperty* newValue = [super copyWithZone:zone];
  [newValue setValue:[self value]];
  [newValue setName:[self name]];
  return newValue;
}

- (BOOL)isEqual:(GDataExtendedProperty *)other {
  if (self == other) return YES;
  if (![other isKindOfClass:[GDataExtendedProperty class]]) return NO;
  
  return [super isEqual:other]
    && AreEqualOrBothNil([self value], [other value])
    && AreEqualOrBothNil([self name], [other name]);
}

- (NSMutableArray *)itemsForDescription {
  NSMutableArray *items = [NSMutableArray array];
  
  [self addToArray:items objectDescriptionIfNonNil:value_ withName:@"value"];
  [self addToArray:items objectDescriptionIfNonNil:name_ withName:@"name"];
  
  return items;
}

- (NSXMLElement *)XMLElement {
  NSXMLElement *element = [self XMLElementWithExtensionsAndDefaultName:nil];
  
  [self addToElement:element attributeValueIfNonNil:[self value] withName:@"value"];
  [self addToElement:element attributeValueIfNonNil:[self name] withName:@"name"];
  
  return element;
}

- (NSString *)value {
  return value_; 
}

- (void)setValue:(NSString *)str {
  [value_ autorelease];
  value_ = [str copy];
}

- (NSString *)name {
  return name_; 
}

- (void)setName:(NSString *)str {
  [name_ autorelease];
  name_ = [str copy];
}

- (NSArray *)XMLValues {
  NSArray *unknownChildren = [self unknownChildren];
  
  if ([unknownChildren count] == 0) {
    return nil;
  }
  return unknownChildren; 
}

- (void)setXMLValues:(NSArray *)arr {
  [self setUnknownChildren:arr]; 
}

- (void)addXMLValue:(NSXMLElement *)element {
  
  NSArray *oldUnknownChildren = [self unknownChildren];
  NSMutableArray *newUnknownChildren;

  if (oldUnknownChildren == nil) {
    newUnknownChildren = [NSMutableArray array]; 
  } else {
    newUnknownChildren = [NSMutableArray arrayWithArray:oldUnknownChildren];
  }
  [newUnknownChildren addObject:element];
                          
  [self setUnknownChildren:newUnknownChildren];
}

@end