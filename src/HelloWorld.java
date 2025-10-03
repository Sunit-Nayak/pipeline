stage('Run Java App') {
    steps {
        sh 'java -cp out HelloWorld' 
    }
}
