//
//  ViewController.m
//  glkit
//
//  Created by Jonathan Blocksom on 1/16/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import "GLCoverPageViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// three xyz coordinates, three normal coordinates, two texture coordinates *
// six vertices per face * 
// six faces per cube
GLfloat gCubeVertexData[(3 + 3 + 2) * 6 * 6] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ, normalX, normalY, normalZ, texCoord0S, texCoord0T,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,    0.0, 0.0,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,    1.0, 0.0,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    0.0, 1.0,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    0.0, 1.0,
    0.5f, 0.5f, 0.5f,          1.0f, 0.0f, 0.0f,    1.0, 1.0,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,    1.0, 0.0,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,    1.0, 0.0,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0.0, 0.0,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    1.0, 1.0,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    1.0, 1.0,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0.0, 0.0,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,    0.0, 1.0,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,    1.0, 0.0,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,    0.0, 0.0,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,    1.0, 1.0,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,    1.0, 1.0,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,    0.0, 0.0,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,    0.0, 1.0,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,    0.0, 0.0,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,    1.0, 0.0,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,    0.0, 1.0,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,    0.0, 1.0,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,    1.0, 0.0,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,    1.0, 1.0,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,    1.0, 1.0,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    0.0, 1.0,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0, 0.0,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1.0, 0.0,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    0.0, 1.0,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,    0.0, 0.0,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,    1.0, 0.0,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,    0.0, 0.0,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,    1.0, 1.0,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,    1.0, 1.0,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,    0.0, 0.0,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,    0.0, 1.0,
};

@interface GLCoverPageViewController () {
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) GLKTextureInfo *regularTexture;
@property (strong, nonatomic) GLKTextureInfo *mipmapTexture;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation GLCoverPageViewController

@synthesize context = _context;
@synthesize effect = _effect;
@synthesize regularTexture = _regularTexture;
@synthesize mipmapTexture = _mipmapTexture;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light0.position = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.0f);
    self.effect.light1.enabled = GL_TRUE;
    self.effect.light1.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light1.position = GLKVector4Make(-1.0f, 0.0f, 0.0f, 0.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
    
    // Load textures
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rick" ofType:@"png"];
    NSDictionary *opts = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, nil];
    NSError *err;
    self.regularTexture = [GLKTextureLoader textureWithContentsOfFile:path options:opts error:&err];
    if (self.regularTexture == nil) {
        NSLog(@"Error loading regular texture: %@", err);
    } else {
        NSLog(@"Loaded regular texture");
    }
    
    self.mipmapTexture = [GLKTextureLoader textureWithContentsOfFile:path options:nil error:&err];
    if (self.mipmapTexture == nil) {
        NSLog(@"Error loading mipmap texture: %@", err);
    } else {
        NSLog(@"Loaded mipmap texture");
    }
    
    // At this w/ regular OpenGL you can use the texture by calling
    // glBindTexture(GL_TEXTURE_2D, sgitex.name);

    // Here's the GLKit way:
    self.effect.texture2d0.name = self.mipmapTexture.name;
    self.effect.texture2d0.enabled = true;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), 
                                                            aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    

    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.16f, 0.32f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the objects
    for (int i=-10; i<10; i++) {
        for (int j=-10; j<11; j++) {
            // Right side
            GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
            baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 1.0f, 0.0f, 0.0f);
            
            GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(4.0f, -4.0f * (float)j, - 4.0f * (float)i);
            modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 3.90f, 3.90f, 3.90f);    
            // modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
            modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
            
            self.effect.transform.modelviewMatrix = modelViewMatrix;
            
            self.effect.texture2d0.name = self.regularTexture.name;
            
            [self.effect prepareToDraw];
            glDrawArrays(GL_TRIANGLES, 0, 36);
            
            // Left side
            modelViewMatrix = GLKMatrix4MakeTranslation(-4.0f, -4.0f * (float)j, - 4.0f * (float)i);
            modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, 3.90f, 3.90f, 3.90f);    
            // modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
            modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
            self.effect.transform.modelviewMatrix = modelViewMatrix;

            self.effect.texture2d0.name = self.mipmapTexture.name;

            [self.effect prepareToDraw];            
            glDrawArrays(GL_TRIANGLES, 0, 36);
        }
    }
}

@end
