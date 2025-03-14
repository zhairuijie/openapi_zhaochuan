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
package main

import (
	"douyincloud-gin-demo/service"
	"log"

	"github.com/gin-gonic/gin"
	"time"
)

func logPeriodically() {
    ticker := time.NewTicker(2 * time.Second)
    defer ticker.Stop()

    for {
        select {
        case <-ticker.C:
            log.Println("定时日志：", time.Now())
        }
    }
}

func main() {
	
	go logPeriodically()
	
	r := gin.Default()

	r.POST("/api/open_api", service.RunOpenApi)

	log.Println("Server init success")
	r.Run(":8000")
	time.Sleep(5 * time.Second)
}
