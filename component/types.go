/*
Copyright (year) Bytedance Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package component

import (
	"context"

	"github.com/pkg/errors"
)

type HelloWorldComponent interface {
	GetName(ctx context.Context, key string) (name string, err error)
	SetName(ctx context.Context, key string, name string) error
}

const Mongo = "mongodb"
const Redis = "redis"

type localCacheComponent map[string]string

func (l localCacheComponent) GetName(ctx context.Context, key string) (string, error) {
	name, ok := l[key]
	if !ok {
		return "", errors.New("key not found")
	}
	return name, nil
}

func (l localCacheComponent) SetName(ctx context.Context, key, name string) error {
	l[key] = name
	return nil
}

var (
	local localCacheComponent
)

//GetComponent 通过传入的component的名称返回实现了HelloWorldComponent接口的component
func GetComponent(component string) (HelloWorldComponent, error) {
	return local, nil
}

func InitComponents() {
	local = make(localCacheComponent)
}
